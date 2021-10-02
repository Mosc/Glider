import 'package:flutter/material.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
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
  final Widget Function() loading;
  final ProviderBase<Object?>? refreshProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (refreshProvider != null) {
      ref.listen(
        refreshProvider!,
        (_) => ref.read(itemNotifierProvider(id).notifier).forceLoad(),
      );
    }

    final AsyncValue<Item> itemValue = ref.watch(itemNotifierProvider(id));

    return itemValue.when(
      data: (Item value) {
        if (value.time == null) {
          return const SizedBox.shrink();
        }

        return ItemTileData(
          value.copyWith(indentation: indentation),
          key: ValueKey<String>('item_$id'),
          root: root,
          onTap: () => onTap?.call(context),
          dense: dense,
          interactive: interactive,
          fadeable: fadeable,
        );
      },
      loading: loading,
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
