import 'package:flutter/material.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/tile_loading.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommentTileLoading extends HookConsumerWidget {
  const CommentTileLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  height: textTheme.bodySmall?.scaledFontSize(context),
                ),
                const Spacer(),
                TileLoadingBlock(
                  width: 80,
                  height: textTheme.bodySmall?.scaledFontSize(context),
                ),
              ],
            ),
            const SizedBox(height: 13),
            for (int i = 0; i < 2; i++) ...<Widget>[
              if (i > 0)
                SizedBox(height: textTheme.bodyMedium?.scaledFontSize(context)),
              for (int j = 0; j < 2; j++) ...<Widget>[
                const SizedBox(height: 2),
                TileLoadingBlock(
                    height: textTheme.bodyMedium?.scaledFontSize(context)),
              ],
              const SizedBox(height: 2),
              TileLoadingBlock(
                width: 120,
                height: textTheme.bodyMedium?.scaledFontSize(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
