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
            SizedBox(height: textTheme.bodySmall?.leading(context)),
            const SizedBox(height: 1),
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
            const SizedBox(height: 1),
            const SizedBox(height: 12),
            SizedBox(height: textTheme.bodyMedium?.leading(context)),
            for (int i = 0; i < 2; i++) ...<Widget>[
              if (i > 0)
                SizedBox(height: textTheme.bodyMedium?.lineHeight(context)),
              for (int j = 0; j < 2; j++) ...<Widget>[
                SizedBox(height: textTheme.bodyMedium?.leading(context)),
                TileLoadingBlock(
                  height: textTheme.bodyMedium?.scaledFontSize(context),
                ),
              ],
              SizedBox(height: textTheme.bodyMedium?.leading(context)),
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
