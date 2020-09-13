import 'package:flutter/material.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:glider/widgets/items/item_tile.dart';

class StoryTileLoading extends StatelessWidget {
  const StoryTileLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 3),
                    TileLoadingBlock(
                      height: textTheme.subtitle1.fontSize,
                    ),
                    const SizedBox(height: 3),
                    TileLoadingBlock(
                      width: 120,
                      height: textTheme.subtitle1.fontSize,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const TileLoadingBlock(
                width: ItemTile.thumbnailSize,
                height: ItemTile.thumbnailSize,
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TileLoadingBlock(
                width: 160,
                height: textTheme.caption.fontSize,
              ),
              const Spacer(),
              TileLoadingBlock(
                width: 80,
                height: textTheme.caption.fontSize,
              ),
            ],
          ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }
}
