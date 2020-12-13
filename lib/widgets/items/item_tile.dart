import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/separator.dart';
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
    this.fadeable = false,
    this.separator = const Separator(),
    @required this.loading,
  }) : super(key: key);

  final int id;
  final Iterable<int> ancestors;
  final Item root;
  final void Function() onTap;
  final bool dense;
  final bool fadeable;
  final Widget separator;
  final Widget Function() loading;

  static const double thumbnailSize = 38;

  @override
  Widget build(BuildContext context) {
    return useProvider(itemProvider(id)).maybeWhen(
      data: (Item item) => ItemTileData(
        item.copyWith(ancestors: ancestors),
        root: root,
        onTap: onTap,
        dense: dense,
        fadeable: fadeable,
        separator: separator,
      ),
      // Show the loading state as an error state for now because it looks okay.
      orElse: loading,
    );
  }
}
