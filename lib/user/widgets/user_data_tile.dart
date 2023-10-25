import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_animation.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/widgets/animated_visibility.dart';
import 'package:glider/common/widgets/hacker_news_text.dart';
import 'package:glider/common/widgets/metadata_widget.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/user/models/user_style.dart';
import 'package:glider/user/typedefs/user_typedefs.dart';
import 'package:glider_domain/glider_domain.dart';

class UserDataTile extends StatelessWidget {
  const UserDataTile(
    this.user, {
    super.key,
    this.blocked = false,
    this.style = UserStyle.full,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
    this.onLongPress,
  });

  final User user;
  final bool blocked;
  final UserStyle style;
  final EdgeInsets padding;
  final UserCallback? onTap;
  final UserCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final hasPrimary = style.showPrimary;
    final hasSecondary = style.showSecondary && user.about != null && !blocked;

    if (!hasPrimary && !hasSecondary) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onTap != null ? () => onTap!(context, user) : null,
      onLongPress:
          onLongPress != null ? () => onLongPress!(context, user) : null,
      child: Padding(
        padding: padding,
        child: AnimatedSize(
          alignment: Alignment.topCenter,
          duration: AppAnimation.emphasized.duration,
          curve: AppAnimation.emphasized.easing,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasPrimary) _buildPrimary(context),
              if (hasSecondary) _buildSecondary(context),
            ].spaced(height: AppSpacing.m),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimary(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: 'user_tile_karma_${user.username}',
          child: AnimatedSize(
            alignment: AlignmentDirectional.centerStart,
            duration: AppAnimation.standard.duration,
            curve: AppAnimation.standard.easing,
            child: MetadataWidget(
              icon: Icons.arrow_upward_outlined,
              label: Text(user.karma.toString()),
            ),
          ),
        ),
        Hero(
          tag: 'user_tile_submitted_${user.username}',
          child: AnimatedVisibility(
            visible: user.submittedIds != null,
            padding: MetadataWidget.horizontalPadding,
            child: MetadataWidget(
              icon: Icons.chat_bubble_outline_outlined,
              label: user.submittedIds != null
                  ? Text(user.submittedIds!.length.toString())
                  : null,
            ),
          ),
        ),
        Hero(
          tag: 'user_tile_blocked_${user.username}',
          child: AnimatedVisibility(
            visible: blocked,
            padding: MetadataWidget.horizontalPadding,
            child: MetadataWidget(
              icon: Icons.block_outlined,
              label: Text(context.l10n.blocked),
            ),
          ),
        ),
        const Spacer(),
        Hero(
          tag: 'user_tile_created_${user.username}',
          child: MetadataWidget(
            label: Tooltip(
              message: user.createdDateTime.toString(),
              child: Text(context.l10n.sinceDate(user.createdDateTime)),
            ),
          ),
        ),
      ].spaced(width: AppSpacing.m),
    );
  }

  Widget _buildSecondary(BuildContext context) {
    return Hero(
      tag: 'user_tile_about_${user.username}',
      child: HackerNewsText(user.about!),
    );
  }
}
