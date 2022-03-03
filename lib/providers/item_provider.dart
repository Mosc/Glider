import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:glider/models/descendant_id.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/api_repository.dart';
import 'package:glider/utils/base_notifier.dart';
import 'package:glider/utils/service_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateProvider<int> previewIdStateProvider =
    StateProvider<int>((StateProviderRef<int> ref) => -1);

final AutoDisposeStateNotifierProvider<FavoriteIdsNotifier,
        AsyncValue<Iterable<int>>> favoriteIdsNotifierProvider =
    StateNotifierProvider.autoDispose(
  (AutoDisposeStateNotifierProviderRef<FavoriteIdsNotifier,
              AsyncValue<Iterable<int>>>
          ref) =>
      FavoriteIdsNotifier(ref.read),
);

class FavoriteIdsNotifier extends BaseNotifier<Iterable<int>> {
  FavoriteIdsNotifier(Reader read) : super(read);

  @override
  Future<Iterable<int>> getData() =>
      read(storageRepositoryProvider).favoriteIds;
}

final AutoDisposeStateNotifierProviderFamily<StoryIdsNotifier,
        AsyncValue<Iterable<int>>, StoryType> storyIdsNotifierProvider =
    StateNotifierProvider.autoDispose.family(
  (AutoDisposeStateNotifierProviderRef<StoryIdsNotifier,
                  AsyncValue<Iterable<int>>>
              ref,
          StoryType storyType) =>
      StoryIdsNotifier(ref.read, storyType),
);

class StoryIdsNotifier extends BaseNotifier<Iterable<int>> {
  StoryIdsNotifier(Reader read, this.storyType) : super(read);

  final StoryType storyType;

  @override
  Future<Iterable<int>> getData() async {
    final ApiRepository apiRepository = read(apiRepositoryProvider);

    if (storyType == StoryType.newTopStories) {
      final Iterable<int> newStoryIds =
          await apiRepository.getStoryIds(StoryType.newStories);
      final Iterable<int> topStoryIds =
          await apiRepository.getStoryIds(StoryType.topStories);
      return newStoryIds.toSet().intersection(topStoryIds.toSet());
    } else {
      return apiRepository.getStoryIds(storyType);
    }
  }
}

final AutoDisposeStateNotifierProviderFamily<ItemIdsSearchNotifier,
        AsyncValue<Iterable<int>>, SearchParameters>
    itemIdsSearchNotifierProvider = StateNotifierProvider.autoDispose.family(
  (AutoDisposeStateNotifierProviderRef<ItemIdsSearchNotifier,
                  AsyncValue<Iterable<int>>>
              ref,
          SearchParameters searchParameters) =>
      ItemIdsSearchNotifier(ref.read, searchParameters),
);

class ItemIdsSearchNotifier extends BaseNotifier<Iterable<int>> {
  ItemIdsSearchNotifier(Reader read, this.searchParameters) : super(read);

  final SearchParameters searchParameters;

  @override
  Future<Iterable<int>> getData() =>
      read(searchApiRepositoryProvider).searchItemIds(searchParameters);
}

final StateNotifierProviderFamily<ItemNotifier, AsyncValue<Item>, int>
    itemNotifierProvider = StateNotifierProvider.family(
  (StateNotifierProviderRef<ItemNotifier, AsyncValue<Item>> ref, int id) =>
      ItemNotifier(ref.read, id: id),
);

class ItemNotifier extends BaseNotifier<Item> {
  ItemNotifier(Reader read, {required this.id}) : super(read);

  final int id;

  @override
  Future<Item> getData() => read(apiRepositoryProvider).getItem(id);
}

final AutoDisposeStreamProviderFamily<ItemTree, int> itemTreeStreamProvider =
    StreamProvider.autoDispose
        .family((AutoDisposeStreamProviderRef<ItemTree> ref, int id) async* {
  unawaited(loadItemTree(ref.read, id: id));

  final Stream<DescendantId> descendantIdStream = _itemStream(ref.read, id: id);
  final List<DescendantId> descendantIds = <DescendantId>[];

  await for (final DescendantId descendantId in descendantIdStream) {
    descendantIds.add(descendantId);
    yield ItemTree(descendantIds: descendantIds, done: false);
  }

  yield ItemTree(descendantIds: descendantIds, done: true);
});

Stream<DescendantId> _itemStream(Reader read,
    {required int id, Iterable<int> ancestors = const <int>[]}) async* {
  try {
    yield DescendantId(id: id, ancestors: ancestors);

    final Item item = await read(itemNotifierProvider(id).notifier).load();

    final Iterable<int> childAncestors = <int>[id, ...ancestors];

    for (final int partId in item.parts) {
      yield* _itemStream(read, id: partId, ancestors: childAncestors);
    }

    for (final int kidId in item.kids) {
      yield* _itemStream(read, id: kidId, ancestors: childAncestors);
    }
  } on ServiceException {
    // Fail silently.
  }
}

Future<void> loadItemTree(Reader read, {required int id}) => _loadItemTree(
      (int id) => read(itemNotifierProvider(id).notifier).load(),
      id: id,
    );

Future<void> reloadItemTree(Reader read, {required int id}) => _loadItemTree(
      (int id) => read(itemNotifierProvider(id).notifier).forceLoad(),
      id: id,
    );

Future<void> _loadItemTree(Future<Item> Function(int) getItem,
    {required int id}) async {
  try {
    final Item item = await getItem(id);

    for (final int id in <int>[...item.parts, ...item.kids]) {
      unawaited(
        SchedulerBinding.instance!.scheduleTask(
          () => _loadItemTree(getItem, id: id),
          Priority.animation,
        ),
      );
    }
  } on ServiceException {
    // Fail silently.
  }
}
