import 'package:flutter/material.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/tile_loading.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:glider/widgets/items/item_tile_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoryTileLoading extends HookConsumerWidget {
  const StoryTileLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double? faviconSize = ItemTileHeader.calculateHeight(context);
    final bool showFavicon = ref.watch(showFaviconProvider).value ?? false;
    final bool showMetadata = ref.watch(showMetadataProvider).value ?? false;

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
                      SizedBox(height: textTheme.titleMedium?.leading(context)),
                      TileLoadingBlock(
                        height: textTheme.titleMedium?.scaledFontSize(context),
                      ),
                      SizedBox(height: textTheme.titleMedium?.leading(context)),
                      TileLoadingBlock(
                        width: 120,
                        height: textTheme.titleMedium?.scaledFontSize(context),
                      ),
                    ],
                  ),
                ),
                if (showFavicon) ...<Widget>[
                  const SizedBox(width: 12),
                  TileLoadingBlock(
                    width: faviconSize,
                    height: faviconSize,
                  ),
                ],
              ],
            ),
            if (showMetadata) ...<Widget>[
              const SizedBox(height: 12),
              const SizedBox(height: 1),
              SizedBox(height: textTheme.bodySmall?.leading(context)),
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
            ],
          ],
        ),
      ),
    );
  }
}
