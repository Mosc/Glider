import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/api_repository.dart';
import 'package:glider/utils/service_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

final StateProvider<int> previewIdStateProvider =
    StateProvider<int>((ProviderReference ref) => -1);

final AutoDisposeFutureProvider<Iterable<int>> favoriteIdsProvider =
    FutureProvider.autoDispose(
  (ProviderReference ref) => ref.read(storageRepositoryProvider).favoriteIds,
);

final AutoDisposeFutureProviderFamily<Iterable<int>, StoryType>
    storyIdsProvider = FutureProvider.autoDispose
        .family((ProviderReference ref, StoryType storyType) async {
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
  (ProviderReference ref, SearchParameters searchParameters) =>
      ref.read(searchApiRepositoryProvider).searchStoryIds(searchParameters),
);

final StateProviderFamily<Item?, int> itemCacheStateProvider =
    StateProvider.family((ProviderReference ref, int id) => null);

final AutoDisposeFutureProviderFamily<Item, int> itemProvider =
    FutureProvider.autoDispose.family((ProviderReference ref, int id) async {
  final Item item = await ref.read(apiRepositoryProvider).getItem(id);
  ref.read(itemCacheStateProvider(id)).state = item;
  return item;
});

final AutoDisposeStreamProviderFamily<ItemTree, int> itemTreeStreamProvider =
    StreamProvider.autoDispose.family((ProviderReference ref, int id) async* {
  unawaited(_preloadItemTree(ref, id: id));

  final Stream<Item> itemStream = _itemStream(ref, id: id);
  final List<Item> items = <Item>[];

  await for (final Item item in itemStream) {
    items.add(item);
    yield ItemTree(items: items, done: false);
  }

  yield ItemTree(items: items, done: true);
});

Stream<Item> _itemStream(ProviderReference ref,
    {required int id, Iterable<int> ancestors = const <int>[]}) async* {
  try {
    final Item item = await _readItem(ref, id: id);

    yield item.copyWith(ancestors: ancestors);

    final Iterable<int> childAncestors = <int>[id, ...ancestors];

    for (final int partId in item.parts) {
      yield* _itemStream(ref, id: partId, ancestors: childAncestors);
    }

    for (final int kidId in item.kids) {
      yield* _itemStream(ref, id: kidId, ancestors: childAncestors);
    }
  } on ServiceException {
    // Fail silently.
  }
}

Future<void> _preloadItemTree(ProviderReference ref, {required int id}) =>
    _loadItemTree((int id) => _readItem(ref, id: id), id: id);

Future<void> reloadItemTree(
        Item Function<Item>(RootProvider<Item, Object>) refresh,
        {required int id}) =>
    _loadItemTree((int id) => refresh(itemProvider(id)), id: id);

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

Future<Item> _readItem(ProviderReference ref, {required int id}) async =>
    ref.read(itemCacheStateProvider(id)).state ??
    await ref.read(itemProvider(id).future);
