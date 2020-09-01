import 'package:glider/models/item.dart';
import 'package:glider/models/item_family.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeFutureProviderFamily<List<int>, NavigationItem>
    storyIdsProvider = FutureProvider.autoDispose
        .family((ProviderReference ref, NavigationItem navigationItem) async {
  final Repository repository = ref.read(repositoryProvider);
  return repository.getStoryIds(navigationItem);
});

final AutoDisposeFutureProviderFamily<Item, int> itemProvider =
    FutureProvider.autoDispose.family((ProviderReference ref, int id) async {
  final Repository repository = ref.read(repositoryProvider);
  return repository.getItem(id);
});

final AutoDisposeFutureProviderFamily<List<Item>, int> itemFamilyProvider =
    FutureProvider.autoDispose.family((ProviderReference ref, int id) async {
  final Repository repository = ref.read(repositoryProvider);
  return repository.getItemFamily(id);
});

final StreamProviderFamily<ItemFamily, int> itemFamilyStreamProvider =
    StreamProvider.family((ProviderReference ref, int id) async* {
  final Repository repository = ref.read(repositoryProvider);
  final Stream<Item> familyStream = repository.getItemFamilyStream(id);
  final List<Item> items = <Item>[];

  await for (final Item item in familyStream) {
    items.add(item);
    yield ItemFamily(items: items, hasMore: true);
  }

  yield ItemFamily(items: items, hasMore: false);
});
