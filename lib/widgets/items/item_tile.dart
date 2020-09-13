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
    this.dense = false,
    this.onTap,
    @required this.loading,
  }) : super(key: key);

  final int id;
  final bool dense;
  final void Function() onTap;
  final Widget Function() loading;

  static const double thumbnailSize = 38;

  @override
  Widget build(BuildContext context) {
    return useProvider(itemProvider(id)).when(
      loading: loading,
      error: (_, __) => const SizedBox.shrink(),
      data: (Item item) => ItemTileData(item, onTap: onTap, dense: dense),
    );
  }
}
