import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/widgets/common/tile_loading.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:glider/widgets/items/item_tile.dart';

class ItemTileThumbnail extends HookWidget {
  const ItemTileThumbnail(this.item, {Key key}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'item_thumbnail_${item.id}',
      child: CachedNetworkImage(
        imageUrl: item.thumbnailUrl,
        imageBuilder: (_, ImageProvider<dynamic> imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        placeholder: (_, __) => const TileLoading(
          child: TileLoadingBlock(),
        ),
        width: ItemTile.thumbnailSize,
        height: ItemTile.thumbnailSize,
      ),
    );
  }
}
