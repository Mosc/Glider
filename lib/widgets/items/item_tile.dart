import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTile extends HookWidget {
  const ItemTile({
    Key key,
    @required this.id,
    this.ancestors,
    this.root,
    this.onTap,
    this.dense = false,
    this.interactive = false,
    this.fadeable = false,
    @required this.loading,
  }) : super(key: key);

  final int id;
  final Iterable<int> ancestors;
  final Item root;
  final void Function(BuildContext) onTap;
  final bool dense;
  final bool interactive;
  final bool fadeable;
  final Widget Function() loading;

  @override
  Widget build(BuildContext context) {
    final Item item = useProvider(itemCacheStateProvider(id)).state ??
        useProvider(itemProvider(id)).data?.value;

    if (item == null) {
      return loading();
    }

    if (item.time == null) {
      return const SizedBox.shrink();
    }

    return ItemTileData(
      item.copyWith(ancestors: ancestors),
      key: ValueKey<int>(id),
      root: root,
      onTap: () => onTap(context),
      dense: dense,
      interactive: interactive,
      fadeable: fadeable,
    );
  }
}
