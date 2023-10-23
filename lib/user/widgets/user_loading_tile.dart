import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/widgets/loading_block.dart';
import 'package:glider/common/widgets/loading_text_block.dart';
import 'package:glider/common/widgets/metadata_widget.dart';
import 'package:glider/user/models/user_style.dart';

class UserLoadingTile extends StatelessWidget {
  const UserLoadingTile({
    super.key,
    this.style = UserStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
  });

  final UserStyle style;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (style.showPrimary) _buildPrimary(context),
          if (style.showSecondary) _buildSecondary(context),
        ].spaced(height: AppSpacing.m),
      ),
    );
  }

  Widget _buildPrimary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color =
        Theme.of(context).colorScheme.outline.withOpacity(LoadingBlock.opacity);
    return Row(
      children: [
        MetadataWidget(
          icon: Icons.arrow_upward_outlined,
          label: LoadingTextBlock(
            width: 28,
            style: textTheme.bodySmall,
            hasLeading: false,
          ),
          color: color,
        ),
        MetadataWidget(
          icon: Icons.chat_bubble_outline_outlined,
          label: LoadingTextBlock(
            width: 21,
            style: textTheme.bodySmall,
            hasLeading: false,
          ),
          color: color,
        ),
        const Spacer(),
        MetadataWidget(
          label: LoadingTextBlock(
            width: 112,
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
