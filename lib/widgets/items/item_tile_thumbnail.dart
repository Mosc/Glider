import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:glider/widgets/items/item_tile_header.dart';
import 'package:octo_image/octo_image.dart';

class ItemTileThumbnail extends HookWidget {
  const ItemTileThumbnail(this.item, {Key? key}) : super(key: key);

  final Item item;

  static final BorderRadius _borderRadius = BorderRadius.circular(4);

  @override
  Widget build(BuildContext context) {
    final double? size = ItemTileHeader.calculateHeight(context);

    return GestureDetector(
      onTap: () => UrlUtil.tryLaunch(item.url!),
      child: Hero(
        tag: 'item_thumbnail_${item.id}',
        child: item.localOnly
            ? _placeholderBuilder(context, size: size)
            : OctoImage(
                image: CachedNetworkImageProvider(item.thumbnailUrl!),
                imageBuilder: (_, Widget child) => ClipRRect(
                  borderRadius: _borderRadius,
                  child: child,
                ),
                placeholderBuilder: (BuildContext context) =>
                    _placeholderBuilder(context, size: size),
                errorBuilder:
                    OctoError.icon(icon: FluentIcons.error_circle_24_regular),
                width: size,
                height: size,
              ),
      ),
    );
  }

  static Widget _placeholderBuilder(BuildContext context, {double? size}) {
    return TileLoadingBlock(
      width: size,
      height: size,
      color: Theme.of(context).colorScheme.surface,
    );
  }
}
