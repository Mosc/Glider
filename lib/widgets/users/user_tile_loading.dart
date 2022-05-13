import 'package:flutter/material.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/tile_loading.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserTileLoading extends HookConsumerWidget {
  const UserTileLoading({super.key});

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
                  width: 160,
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
            SizedBox(height: textTheme.bodySmall?.leading(context)),
            for (int i = 0; i < 2; i++) ...<Widget>[
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
        ),
      ),
    );
  }
}
