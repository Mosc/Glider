import 'dart:async';

import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/api_repository.dart';
import 'package:glider/utils/service_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final StateProvider<int> previewIdStateProvider =
    StateProvider<int>((StateProviderRef<int> ref) => -1);

final AutoDisposeFutureProvider<Iterable<int>> favoriteIdsProvider =
    FutureProvider.autoDispose<Iterable<int>>(
  (AutoDisposeFutureProviderRef<Iterable<int>> ref) =>
      ref.read(storageRepositoryProvider).favoriteIds,
);

final AutoDisposeFutureProviderFamily<Iterable<int>, StoryType>
    storyIdsProvider = FutureProvider.autoDispose.family(
        (AutoDisposeFutureProviderRef<Iterable<int>> ref,
            StoryType storyType) async {
  final ApiRepository apiRepository = ref.read(apiRepositoryProvider);

  if (storyType == StoryType.newTopStories) {
    final Iterable<int> newStoryIds =
        await apiRepository.getStoryIds(StoryType.newStories);
    final Iterable<int> topStoryIds =
        await apiRepository.getStoryIds(StoryType.topStories);
    return newStoryIds.toSet().intersection(topStoryIds.toSet());
  }

  return apiRepository.getStoryIds(storyType);
});

final AutoDisposeFutureProviderFamily<Iterable<int>, SearchParameters>
    storyIdsSearchProvider = FutureProvider.autoDispose.family(
  (AutoDisposeFutureProviderRef<Iterable<int>> ref,
          SearchParameters searchParameters) =>
      ref.read(searchApiRepositoryProvider).searchStoryIds(searchParameters),
);

final StateNotifierProviderFamily<ItemNotifier, AsyncValue<Item>, int>
    itemNotifierProvider = StateNotifierProvider.family(
  (StateNotifierProviderRef ref, int id) => ItemNotifier(ref.read, id: id),
);

class ItemNotifier extends StateNotifier<AsyncValue<Item>> {
  ItemNotifier(this.read, {required this.id})
      : super(const AsyncValue<Item>.loading()) {
    load();
  }

  final Reader read;
  final int id;

  void setData(Item item) => state = AsyncValue<Item>.data(item);

  Future<Item> load() async {
    return state.maybeWhen(
      data: (Item state) => state,
      orElse: forceLoad,
    );
  }

  Future<Item> forceLoad() async {
    final Item item = await read(apiRepositoryProvider).getItem(id);
    setData(item);
    return item;
  }
}

final AutoDisposeStreamProviderFamily<ItemTree, int> itemTreeStreamProvider =
    StreamProvider.autoDispose
        .family((AutoDisposeStreamProviderRef<ItemTree> ref, int id) async* {
  unawaited(loadItemTree(ref.read, id: id));

  final Stream<Item> itemStream = _itemStream(ref.read, id: id);
  final List<Item> items = <Item>[];

  await for (final Item item in itemStream) {
    items.add(item);
    yield ItemTree(items: items, done: false);
  }

  yield ItemTree(items: items, done: true);
});

Stream<Item> _itemStream(Reader read,
    {required int id, Iterable<int> ancestors = const <int>[]}) async* {
  try {
    final Item item = await read(itemNotifierProvider(id).notifier).load();

    yield item.copyWith(ancestors: ancestors);

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

    await Future.wait(
      item.parts.map((int partId) => _loadItemTree(getItem, id: partId)),
    );

    await Future.wait(
      item.kids.map((int kidId) => _loadItemTree(getItem, id: kidId)),
    );
  } on ServiceException {
    // Fail silently.
  }
}
