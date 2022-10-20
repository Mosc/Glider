import 'dart:async';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/search_order.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/models/search_result.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/models/tree_item.dart';
import 'package:glider/models/user.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:glider/utils/service_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:queue/queue.dart';

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
        AsyncStateNotifier<Iterable<TreeItem>>,
        AsyncValue<Iterable<TreeItem>>,
        String> itemRepliesNotifierProvider =
    StateNotifierProvider.autoDispose.family(
  (AutoDisposeStateNotifierProviderRef<AsyncStateNotifier<Iterable<TreeItem>>,
                  AsyncValue<Iterable<TreeItem>>>
              ref,
          String username) =>
      AsyncStateNotifier<Iterable<TreeItem>>(() async {
    final User user = await ref.read(apiRepositoryProvider).getUser(username);
    final SearchResult searchResult =
        await ref.read(searchApiRepositoryProvider).searchItems(
              SearchParameters.replies(
                order: SearchOrder.byDate,
                parentIds: user.submitted,
              ),
            );

    return <TreeItem>[
      for (final SearchResultHit hit in searchResult.hits)
        if (hit.parentId != null) ...<TreeItem>[
          TreeItem(id: hit.parentId!),
          TreeItem(
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
    final Queue queue = Queue(parallel: 8);
    final Stream<TreeItem> treeItemStream =
        _itemStream(ref, id: id, queue: queue);
    final List<TreeItem> treeItems = <TreeItem>[TreeItem(id: id)];

    yield ItemTree(treeItems: treeItems, done: false);

    await for (final TreeItem treeItem in treeItemStream) {
      treeItems.forEachIndexed((int index, TreeItem oldTreeItem) {
        if (treeItem.ancestorIds.contains(oldTreeItem.id)) {
          treeItems[index] = oldTreeItem.copyWith(
            descendantIds: <int>[...oldTreeItem.descendantIds, treeItem.id],
          );
        }
      });

      final int index = treeItems
          .indexWhere((TreeItem oldTreeItem) => oldTreeItem.id == treeItem.id);
      treeItems.insertAll(index + 1, treeItem.childTreeItems);

      yield ItemTree(treeItems: treeItems, done: false);
    }

    yield ItemTree(treeItems: treeItems);
  },
);

Stream<TreeItem> _itemStream(
  Ref<AsyncValue<ItemTree>> ref, {
  required int id,
  Iterable<int> ancestorIds = const <int>[],
  Queue? queue,
}) async* {
  try {
    final AsyncStateNotifier<Item> itemNotifier =
        ref.read(itemNotifierProvider(id).notifier);
    final Item item = queue != null
        ? await queue.add(itemNotifier.forceLoad)
        : await itemNotifier.forceLoad();

    if (!item.deleted) {
      final List<int> childIds = <int>[...item.parts, ...item.kids];
      final List<int> childAncestorIds = <int>[id, ...ancestorIds];

      yield TreeItem(
        id: id,
        childTreeItems: <TreeItem>[
          for (final int childId in childIds)
            TreeItem(id: childId, ancestorIds: childAncestorIds),
        ],
        ancestorIds: ancestorIds,
      );

      yield* StreamGroup.merge(
        <Stream<TreeItem>>[
          for (final int childId in childIds)
            _itemStream(
              ref,
              id: childId,
              ancestorIds: childAncestorIds,
              queue: queue,
            ),
        ],
      );
    }
  } on ServiceException {
    // Fail silently.
  }
}
