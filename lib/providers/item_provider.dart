import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/item_tree_id.dart';
import 'package:glider/models/search_order.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/models/search_result.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/models/user.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:glider/utils/service_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateProvider<int> previewIdStateProvider =
    StateProvider<int>((StateProviderRef<int> ref) => -1);

final AutoDisposeStateNotifierProvider<AsyncStateNotifier<Iterable<int>>,
        AsyncValue<Iterable<int>>> favoriteIdsNotifierProvider =
    StateNotifierProvider.autoDispose(
  (AutoDisposeStateNotifierProviderRef<AsyncStateNotifier<Iterable<int>>,
              AsyncValue<Iterable<int>>>
          ref) =>
      AsyncStateNotifier<Iterable<int>>(
    () => ref.read(storageRepositoryProvider).favoriteIds,
  ),
);

final AutoDisposeStateNotifierProviderFamily<AsyncStateNotifier<Iterable<int>>,
        AsyncValue<Iterable<int>>, StoryType> storyIdsNotifierProvider =
    StateNotifierProvider.autoDispose.family(
  (AutoDisposeStateNotifierProviderRef<AsyncStateNotifier<Iterable<int>>,
                  AsyncValue<Iterable<int>>>
              ref,
          StoryType storyType) =>
      AsyncStateNotifier<Iterable<int>>(
    () => ref.read(apiRepositoryProvider).getStoryIds(storyType),
  ),
);

final AutoDisposeStateNotifierProviderFamily<AsyncStateNotifier<Iterable<int>>,
        AsyncValue<Iterable<int>>, SearchParameters>
    itemIdsSearchNotifierProvider = StateNotifierProvider.autoDispose.family(
  (AutoDisposeStateNotifierProviderRef<AsyncStateNotifier<Iterable<int>>,
                  AsyncValue<Iterable<int>>>
              ref,
          SearchParameters searchParameters) =>
      AsyncStateNotifier<Iterable<int>>(
    () => ref.read(searchApiRepositoryProvider).searchItemIds(searchParameters),
  ),
);
final AutoDisposeStateNotifierProviderFamily<
        AsyncStateNotifier<Iterable<ItemTreeId>>,
        AsyncValue<Iterable<ItemTreeId>>,
        String> itemRepliesNotifierProvider =
    StateNotifierProvider.autoDispose.family(
  (AutoDisposeStateNotifierProviderRef<AsyncStateNotifier<Iterable<ItemTreeId>>,
                  AsyncValue<Iterable<ItemTreeId>>>
              ref,
          String username) =>
      AsyncStateNotifier<Iterable<ItemTreeId>>(() async {
    final User user = await ref.read(apiRepositoryProvider).getUser(username);
    final SearchResult searchResult =
        await ref.read(searchApiRepositoryProvider).searchItems(
              SearchParameters.replies(
                order: SearchOrder.byDate,
                parentIds: user.submitted,
              ),
            );

    return <ItemTreeId>[
      for (final SearchResultHit hit in searchResult.hits)
        if (hit.parentId != null) ...<ItemTreeId>[
          ItemTreeId(id: hit.parentId!),
          ItemTreeId(
            id: int.parse(hit.id),
            ancestorIds: <int>[hit.parentId!],
          ),
        ]
    ];
  }),
);

final StateNotifierProviderFamily<AsyncStateNotifier<Item>, AsyncValue<Item>,
    int> itemNotifierProvider = StateNotifierProvider.family(
  (StateNotifierProviderRef<AsyncStateNotifier<Item>, AsyncValue<Item>> ref,
          int id) =>
      AsyncStateNotifier<Item>(
    () => ref.read(apiRepositoryProvider).getItem(id),
  ),
);

final AutoDisposeStreamProviderFamily<ItemTree, int> itemTreeStreamProvider =
    StreamProvider.autoDispose.family(
  (AutoDisposeStreamProviderRef<ItemTree> ref, int id) async* {
    unawaited(_loadItemTree(ref, id: id));

    final Stream<ItemTreeId> itemTreeIdStream = _itemStream(ref, id: id);
    Iterable<ItemTreeId> itemTreeIds = <ItemTreeId>[];

    await for (final ItemTreeId newItemTreeId in itemTreeIdStream) {
      itemTreeIds = <ItemTreeId>[
        for (final ItemTreeId itemTreeId in itemTreeIds)
          newItemTreeId.ancestorIds.contains(itemTreeId.id)
              ? itemTreeId.copyWith(
                  descendantIds: <int>[
                    ...itemTreeId.descendantIds,
                    newItemTreeId.id,
                  ],
                )
              : itemTreeId,
        newItemTreeId,
      ];
      yield ItemTree(itemTreeIds: itemTreeIds, done: false);
    }

    yield ItemTree(itemTreeIds: itemTreeIds);
  },
);

Stream<ItemTreeId> _itemStream(Ref<AsyncValue<ItemTree>> ref,
    {required int id, Iterable<int> ancestorIds = const <int>[]}) async* {
  try {
    final Item item = await ref.read(itemNotifierProvider(id).notifier).load();

    if (!(item.deleted ?? false)) {
      yield ItemTreeId(id: id, ancestorIds: ancestorIds);
    }

    final Iterable<int> childAncestorIds = <int>[id, ...ancestorIds];

    for (final int partId in item.parts) {
      yield* _itemStream(ref, id: partId, ancestorIds: childAncestorIds);
    }

    for (final int kidId in item.kids) {
      yield* _itemStream(ref, id: kidId, ancestorIds: childAncestorIds);
    }
  } on ServiceException {
    // Fail silently.
  }
}

Future<void> _loadItemTree<T>(Ref<AsyncValue<T>> ref, {required int id}) async {
  try {
    final Item item =
        await ref.read(itemNotifierProvider(id).notifier).forceLoad();

    for (final int id in <int>[...item.parts, ...item.kids]) {
      unawaited(
        SchedulerBinding.instance.scheduleTask(
          () => _loadItemTree(ref, id: id),
          Priority.animation,
        ),
      );
    }
  } on ServiceException {
    // Fail silently.
  }
}
