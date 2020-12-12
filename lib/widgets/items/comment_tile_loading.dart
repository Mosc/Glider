import 'package:flutter/material.dart';
import 'package:glider/widgets/common/tile_loading.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';

class CommentTileLoading extends StatelessWidget {
  const CommentTileLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return TileLoading(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TileLoadingBlock(
                  width: 80,
                  height: textTheme.caption.fontSize,
                ),
                const Spacer(),
                TileLoadingBlock(
                  width: 80,
                  height: textTheme.caption.fontSize,
                ),
              ],
            ),
            const SizedBox(height: 13),
            for (int i in List<int>.generate(2, (int i) => i)) ...<Widget>[
              if (i > 0) SizedBox(height: textTheme.bodyText2.fontSize),
              for (int _ in List<int>(2)) ...<Widget>[
                const SizedBox(height: 2),
                TileLoadingBlock(height: textTheme.bodyText2.fontSize),
              ],
              const SizedBox(height: 2),
              TileLoadingBlock(
                width: 120,
                height: textTheme.bodyText2.fontSize,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
