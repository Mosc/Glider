import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/item_tree_parameter.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/service_exception.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: implementation_imports
import 'package:riverpod/src/framework.dart';

final AutoDisposeFutureProviderFamily<Iterable<int>, NavigationItem>
    storyIdsProvider = FutureProvider.autoDispose.family(
        (AutoDisposeProviderReference ref, NavigationItem navigationItem) =>
            ref.read(apiRepositoryProvider).getStoryIds(navigationItem));

final AutoDisposeFutureProviderFamily<Item, int> itemProvider = FutureProvider
    .autoDispose
    .family((AutoDisposeProviderReference ref, int id) =>
        ref.read(apiRepositoryProvider).getItem(id));

final AutoDisposeFutureProviderFamily<ItemTree, ItemTreeParameter>
    itemTreeProvider = FutureProvider.autoDispose.family(
        (AutoDisposeProviderReference ref, ItemTreeParameter parameter) async {
  final Item item = await ref.watch(itemProvider(parameter.id).future);

  if (item == null) {
    return ItemTree(items: <Item>[], hasMore: false);
  }

  final List<Item> items = <Item>[
    item.copyWith(ancestors: parameter.ancestors ?? <int>[]),
  ];

  if (item.kids != null) {
    try {
      final Iterable<ItemTree> tree = await Future.wait(
        item.kids.map(
          (int kidId) => ref.watch(
            itemTreeProvider(
              ItemTreeParameter(id: kidId, ancestors: <int>[
                parameter.id,
                if (parameter.ancestors != null) ...parameter.ancestors,
              ]),
            ).future,
          ),
        ),
      );
      items.addAll(tree.expand((ItemTree kid) => kid.items));
    } on ServiceException {
      // Fail silently.
    }
  }

  return ItemTree(items: items, hasMore: false);
});

final AutoDisposeStreamProviderFamily<ItemTree, ItemTreeParameter>
    itemTreeStreamProvider = StreamProvider.autoDispose.family(
        (AutoDisposeProviderReference ref, ItemTreeParameter parameter) async* {
  final Stream<Item> itemStream =
      ref.watch(_itemStreamProvider(parameter).stream);

  final List<Item> items = <Item>[];

  await for (final Item item in itemStream) {
    items.add(item);
    yield ItemTree(items: items, hasMore: true);
  }

  yield ItemTree(items: items, hasMore: false);
});

final AutoDisposeStreamProviderFamily<Item, ItemTreeParameter>
    _itemStreamProvider = StreamProvider.autoDispose.family(
        (AutoDisposeProviderReference ref, ItemTreeParameter parameter) async* {
  final Item item = await ref.watch(itemProvider(parameter.id).future);

  if (item == null) {
    return;
  }

  yield item.copyWith(ancestors: parameter.ancestors ?? <int>[]);

  if (item.kids != null) {
    for (final int kidId in item.kids) {
      try {
        final Stream<Item> itemStream = ref.read(
          _itemStreamProvider(
            ItemTreeParameter(id: kidId, ancestors: <int>[
              parameter.id,
              if (parameter.ancestors != null) ...parameter.ancestors,
            ]),
          ).stream,
        );

        await for (final Item item in itemStream) {
          yield item;
        }
      } on ServiceException {
        // Fail silently.
      }
    }
  }
});
