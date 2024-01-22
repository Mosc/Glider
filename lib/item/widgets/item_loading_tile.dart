import 'package:flutter/material.dart';
import 'package:glider/app/extensions/text_scaler_extension.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/widgets/loading_block.dart';
import 'package:glider/common/widgets/loading_text_block.dart';
import 'package:glider/common/widgets/metadata_widget.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider_domain/glider_domain.dart';

class ItemLoadingTile extends StatelessWidget {
  const ItemLoadingTile({
    super.key,
    required this.type,
    this.collapsedCount,
    this.storyLines = 2,
    this.useLargeStoryStyle = true,
    this.showMetadata = true,
    this.style = ItemStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
  });

  final ItemType type;
  final int? collapsedCount;
  final int storyLines;
  final bool useLargeStoryStyle;
  final bool showMetadata;
  final ItemStyle style;
  final EdgeInsetsGeometry padding;

  int get _faviconSize =>
      useLargeStoryStyle ? (storyLines >= 0 ? storyLines : 2) * 24 : 20;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (style.showPrimary && (type != ItemType.comment || showMetadata))
            _buildPrimary(context),
          if (style.showSecondary &&
              type == ItemType.comment &&
              collapsedCount == null)
            _buildSecondary(context),
        ],
      ),
    );
  }

  Widget _buildPrimary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        if (type != ItemType.comment)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0;
                        i < (storyLines >= 0 ? storyLines : 2) - 1;
                        i++)
                      LoadingTextBlock(
                        style: useLargeStoryStyle
                            ? textTheme.titleMedium
                            : textTheme.titleSmall,
                      ),
                    LoadingTextBlock(
                      width: 200,
                      style: useLargeStoryStyle
                          ? textTheme.titleMedium
                          : textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              LoadingBlock(
                width: _faviconSize.toDouble(),
                height: _faviconSize.toDouble(),
              ),
            ].spaced(width: AppSpacing.xl),
          ),
        if (showMetadata) _buildMetadata(context),
      ].spaced(height: AppSpacing.s),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color =
        Theme.of(context).colorScheme.outline.withOpacity(LoadingBlock.opacity);
    return Row(
      children: [
        if (type != ItemType.comment) ...[
          MetadataWidget(
            icon: Icons.arrow_upward_outlined,
            label: LoadingTextBlock(
              width: 14,
              style: textTheme.bodySmall,
              hasLeading: false,
            ),
            color: color,
          ),
          MetadataWidget(
            icon: Icons.chat_bubble_outline_outlined,
            label: LoadingTextBlock(
              width: 14,
              style: textTheme.bodySmall,
              hasLeading: false,
            ),
            color: color,
          ),
        ],
        ElevatedButton.icon(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            padding: ButtonStyleButton.scaledPadding(
              const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              MediaQuery.textScalerOf(context).getFontSizeMultiplier(
                fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                fallbackFontSize: 14,
              ),
            ),
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const LoadingBlock(
            width: 14,
            height: 14,
          ),
          label: LoadingTextBlock(
            width: 63,
            style: textTheme.bodySmall,
            hasLeading: false,
          ),
        ),
        if (collapsedCount != null)
          MetadataWidget(
            icon: Icons.add_circle_outline_outlined,
            color: color,
          ),
        const Spacer(),
        MetadataWidget(
          label: LoadingTextBlock(
            width: 70,
            style: textTheme.bodySmall,
            hasLeading: false,
          ),
        ),
      ].spaced(width: AppSpacing.m),
    );
  }

  Widget _buildSecondary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (style.showPrimary) const SizedBox(height: AppSpacing.m),
        LoadingTextBlock(
          style: textTheme.bodyMedium,
        ),
        LoadingTextBlock(
          style: textTheme.bodyMedium,
        ),
        LoadingTextBlock(
          width: 200,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
