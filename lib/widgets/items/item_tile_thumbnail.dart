import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:octo_image/octo_image.dart';

class ItemTileThumbnail extends HookWidget {
  const ItemTileThumbnail(this.item, {Key key}) : super(key: key);

  final Item item;

  static final BorderRadius _borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'item_thumbnail_${item.id}',
      child: OctoImage(
        image: CachedNetworkImageProvider(item.thumbnailUrl),
        imageBuilder: (_, Widget child) => ClipRRect(
          borderRadius: _borderRadius,
          child: child,
        ),
        placeholderBuilder: (_) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: _borderRadius,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        errorBuilder: OctoError.icon(icon: FluentIcons.error_circle_24_regular),
        width: ItemTile.thumbnailSize,
        height: ItemTile.thumbnailSize,
      ),
    );
  }
}
