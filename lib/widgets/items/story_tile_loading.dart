import 'package:flutter/material.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/tile_loading.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:glider/widgets/items/item_tile_header.dart';

class StoryTileLoading extends StatelessWidget {
  const StoryTileLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double thumbnailSize = ItemTileHeader.calculateHeight(context);

    return TileLoading(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                        height: textTheme.subtitle1.scaledFontSize(context),
                      ),
                      const SizedBox(height: 3),
                      TileLoadingBlock(
                        width: 120,
                        height: textTheme.subtitle1.scaledFontSize(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                TileLoadingBlock(
                  width: thumbnailSize,
                  height: thumbnailSize,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TileLoadingBlock(
                  width: 160,
                  height: textTheme.caption.scaledFontSize(context),
                ),
                const Spacer(),
                TileLoadingBlock(
                  width: 80,
                  height: textTheme.caption.scaledFontSize(context),
                ),
              ],
            ),
            const SizedBox(height: 1),
          ],
        ),
      ),
    );
  }
}
