import 'package:flutter/foundation.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/api_repository.dart';
import 'package:glider/utils/service_exception.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

final AutoDisposeFutureProvider<Iterable<int>> favoriteIdsProvider =
    FutureProvider.autoDispose(
  (ProviderReference ref) => ref.read(storageRepositoryProvider).favoriteIds,
);

final AutoDisposeFutureProviderFamily<Iterable<int>, NavigationItem>
    storyIdsProvider = FutureProvider.autoDispose
        .family((ProviderReference ref, NavigationItem navigationItem) async {
  final ApiRepository apiRepository = ref.read(apiRepositoryProvider);

  if (navigationItem == NavigationItem.newTopStories) {
    final Iterable<int> newStoryIds =
        await apiRepository.getStoryIds(NavigationItem.newStories);
    final Iterable<int> topStoryIds =
        await apiRepository.getStoryIds(NavigationItem.topStories);
    return newStoryIds.toSet().intersection(topStoryIds.toSet());
  }

  return apiRepository.getStoryIds(navigationItem);
});

final AutoDisposeStateProviderFamily<Item, int> itemOverrideProvider =
    StateProvider.autoDispose.family((ProviderReference ref, int id) => null);

final FutureProviderFamily<Item, int> itemProvider =
    FutureProvider.family((ProviderReference ref, int id) async {
  final Item itemOverride = ref.read(itemOverrideProvider(id)).state;

  if (itemOverride != null) {
    return itemOverride;
  }

  return ref.read(apiRepositoryProvider).getItem(id);
});

final AutoDisposeStreamProviderFamily<ItemTree, int> itemTreeStreamProvider =
    StreamProvider.autoDispose.family((ProviderReference ref, int id) async* {
  unawaited(_preloadItemTree(ref, id: id));

  final Stream<Item> itemStream = _itemStream(ref, id: id);
  final List<Item> items = <Item>[];

  await for (final Item item in itemStream) {
    items.add(item);
    yield ItemTree(items: items, hasMore: true);
  }

  yield ItemTree(items: items, hasMore: false);
});

Stream<Item> _itemStream(ProviderReference ref,
    {@required int id, Iterable<int> ancestors = const <int>[]}) async* {
  try {
    final Item item = await ref.read(itemProvider(id).future);

    if (item == null) {
      return;
    }

    yield item.copyWith(ancestors: ancestors);

    final Iterable<int> childAncestors = <int>[id, ...ancestors];

    if (item.parts != null) {
      for (final int partId in item.parts) {
        yield* _itemStream(ref, id: partId, ancestors: childAncestors);
      }
    }

    if (item.kids != null) {
      for (final int kidId in item.kids) {
        yield* _itemStream(ref, id: kidId, ancestors: childAncestors);
      }
    }
  } on ServiceException {
    // Fail silently.
  }
}

Future<void> _preloadItemTree(ProviderReference ref, {@required int id}) async {
  try {
    final Item item = await ref.container.refresh(itemProvider(id));

    if (item.parts != null) {
      await Future.wait(
        item.parts.map((int partId) => _preloadItemTree(ref, id: partId)),
      );
    }

    if (item.kids != null) {
      await Future.wait(
        item.kids.map((int kidId) => _preloadItemTree(ref, id: kidId)),
      );
    }
  } on ServiceException {
    // Fail silently.
  }
}
