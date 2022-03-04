import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTile extends HookConsumerWidget {
  const ItemTile({
    Key? key,
    required this.id,
    this.indentation = 0,
    this.root,
    this.onTap,
    this.dense = false,
    this.interactive = false,
    this.fadeable = false,
    required this.loading,
    this.refreshProvider,
  }) : super(key: key);

  final int id;
  final int indentation;
  final Item? root;
  final void Function(BuildContext)? onTap;
  final bool dense;
  final bool interactive;
  final bool fadeable;
  final Widget Function({int indentation}) loading;
  final ProviderBase<Object?>? refreshProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (refreshProvider != null) {
      ref.listen<void>(
        refreshProvider!,
        (_, __) => ref.read(itemNotifierProvider(id).notifier).forceLoad(),
      );
    }

    final AsyncValue<Item> asyncItem = ref.watch(itemNotifierProvider(id));

    return asyncItem.when(
      data: (Item item) => _itemBuilder(context, ref, item),
      loading: () => loading(indentation: indentation),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _itemBuilder(BuildContext context, WidgetRef ref, Item item) {
    if (item.time == null) {
      return const SizedBox.shrink();
    }

    if (item.by != null &&
        (ref.watch(blockedProvider(item.by!)).value ?? false)) {
      return const SizedBox.shrink();
    }

    return ItemTileData(
      item.copyWith(indentation: indentation),
      key: ValueKey<String>('item_$id'),
      root: root,
      onTap: () => onTap?.call(context),
      dense: dense,
      interactive: interactive,
      fadeable: fadeable,
    );
  }
}
