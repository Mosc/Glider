import 'dart:math';

import 'package:flutter/material.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/uri_extension.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/widgets/animated_visibility.dart';
import 'package:glider/common/widgets/decorated_card.dart';
import 'package:glider/common/widgets/hacker_news_text.dart';
import 'package:glider/common/widgets/metadata_widget.dart';
import 'package:glider/item/extensions/item_extension.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/models/vote_type.dart';
import 'package:glider/item/typedefs/item_typedefs.dart';
import 'package:glider/item/widgets/username_widget.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:relative_time/relative_time.dart';

const _faviconRequestSize = 64;

class ItemDataTile extends StatelessWidget {
  const ItemDataTile(
    this.item, {
    super.key,
    this.parsedText,
    this.visited = false,
    this.vote,
    this.favorited = false,
    this.flagged = false,
    this.blocked = false,
    this.filtered = false,
    this.failed = false,
    this.collapsedCount,
    this.storyLines = 2,
    this.useLargeStoryStyle = true,
    this.showFavicons = true,
    this.showMetadata = true,
    this.showUserAvatars = true,
    this.useInAppBrowser = false,
    this.style = ItemStyle.full,
    this.usernameStyle = UsernameStyle.none,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
    this.onLongPress,
    this.onTapFavorite,
    this.onTapUpvote,
  });

  final Item item;
  final ParsedData? parsedText;
  final bool visited;
  final VoteType? vote;
  final bool favorited;
  final bool flagged;
  final bool blocked;
  final bool filtered;
  final bool failed;
  final int? collapsedCount;
  final int storyLines;
  final bool useLargeStoryStyle;
  final bool showFavicons;
  final bool showMetadata;
  final bool showUserAvatars;
  final bool useInAppBrowser;
  final ItemStyle style;
  final UsernameStyle usernameStyle;
  final EdgeInsets padding;
  final ItemCallback? onTap;
  final ItemCallback? onLongPress;
  final VoidCallback? onTapUpvote;
  final VoidCallback? onTapFavorite;

  @override
  Widget build(BuildContext context) {
    if (item.type == ItemType.pollopt) {
      return SwitchListTile.adaptive(
        value: vote.upvoted,
        onChanged: (value) => onTap?.call(context, item),
        title: Row(
          children: [
            if (item.text case final text?)
              Expanded(
                child: Hero(
                  tag: 'item_tile_text_${item.id}',
                  child: HackerNewsText(
                    text,
                    parsedData: parsedText,
                    useInAppBrowser: useInAppBrowser,
                  ),
                ),
              )
            else
              const Spacer(),
            Hero(
              tag: 'item_tile_score_${item.id}',
              child: _buildVotedMetadata(context),
            ),
          ].spaced(width: AppSpacing.s),
        ),
        contentPadding: padding.copyWith(top: 0, bottom: 0),
        visualDensity: VisualDensity.compact,
      );
    }

    final hasPrimary = style.showPrimary &&
        item.dateTime != null &&
        (showMetadata ||
            (item.title != null || item.url != null) && !blocked && !filtered);
    final hasSecondary = style.showSecondary &&
        (item.text != null || item.url != null) &&
        !blocked &&
        !filtered;

    if (!hasPrimary && !hasSecondary) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onTap != null ? () => onTap!(context, item) : null,
      onLongPress:
          onLongPress != null ? () => onLongPress!(context, item) : null,
      child: Padding(
        padding: padding,
        child: Opacity(
          opacity: visited ? 2 / 3 : 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasPrimary) _buildPrimary(context),
              if (hasSecondary && collapsedCount == null)
                _buildSecondary(context),
            ].spaced(height: AppSpacing.m),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimary(BuildContext context) {
    return Column(
      children: [
        if ((item.title != null || item.url != null) && !blocked && !filtered)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.title != null)
                Expanded(
                  child: Hero(
                    tag: 'item_tile_title_${item.id}',
                    child: _ItemTitle(
                      item,
                      storyLines: storyLines,
                      useLargeStoryStyle: useLargeStoryStyle,
                      style: style,
                    ),
                  ),
                )
              else
                const Spacer(),
              if (item.url != null && showFavicons)
                AnimatedVisibility(
                  visible: style == ItemStyle.overview,
                  child: InkWell(
                    onTap: () async => item.url!.tryLaunch(
                      context,
                      useInAppBrowser: useInAppBrowser,
                    ),
                    // Explicitly override parent widget's long press.
                    onLongPress: () {},
                    child: _ItemFavicon(
                      item,
                      storyLines: storyLines,
                      useLargeStoryStyle: useLargeStoryStyle,
                    ),
                  ),
                ),
            ].spaced(width: AppSpacing.xl),
          ),
        if (showMetadata) _buildMetadata(context),
      ].spaced(height: AppSpacing.s),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: 'item_tile_collapsed_${item.id}',
          child: AnimatedVisibility(
            visible: collapsedCount != null,
            padding: MetadataWidget.horizontalPadding,
            child: MetadataWidget(
              icon: Icons.add_circle_outline_outlined,
              label: collapsedCount != null && collapsedCount! > 0
                  ? Text(collapsedCount.toString())
                  : null,
            ),
          ),
        ),
        Hero(
          tag: 'item_tile_favorited_${item.id}',
          child: onTapFavorite != null
              ? _MetadataActionButton(
                  padding: MetadataWidget.horizontalPadding,
                  onTap: onTapFavorite,
                  child: _buildFavoritedMetadata(context),
                )
              : AnimatedVisibility(
                  visible: favorited,
                  padding: MetadataWidget.horizontalPadding,
                  child: _buildFavoritedMetadata(context),
                ),
        ),
        if (item.type != ItemType.job)
          Hero(
            tag: 'item_tile_score_${item.id}',
            child: onTapUpvote != null
                ? _MetadataActionButton(
                    padding: MetadataWidget.horizontalPadding,
                    onTap: onTapUpvote,
                    child: _buildVotedMetadata(context),
                  )
                : AnimatedVisibility(
                    visible: item.score != null || vote != null,
                    padding: MetadataWidget.horizontalPadding,
                    child: _buildVotedMetadata(context),
                  ),
          ),
        Hero(
          tag: 'item_tile_descendants_${item.id}',
          child: AnimatedVisibility(
            visible: item.descendantCount != null,
            padding: MetadataWidget.horizontalPadding,
            child: MetadataWidget(
              icon: Icons.mode_comment_outlined,
              label: item.descendantCount != null
                  ? Text(item.descendantCount!.toString())
                  : null,
            ),
          ),
        ),
        Hero(
          tag: 'item_tile_dead_${item.id}',
          child: AnimatedVisibility(
            visible: item.isDead || flagged,
            padding: MetadataWidget.horizontalPadding,
            child: MetadataWidget(
              icon: Icons.flag_outlined,
              color: flagged ? Theme.of(context).colorScheme.tertiary : null,
            ),
          ),
        ),
        Hero(
          tag: 'item_tile_blocked_${item.id}',
          child: AnimatedVisibility(
            visible: blocked,
            padding: MetadataWidget.horizontalPadding,
            child: MetadataWidget(
              icon: Icons.block_outlined,
              label: Text(context.l10n.blocked),
            ),
          ),
        ),
        Hero(
          tag: 'item_tile_filtered_${item.id}',
          child: AnimatedVisibility(
            visible: filtered,
            padding: MetadataWidget.horizontalPadding,
            child: const MetadataWidget(
              icon: Icons.filter_alt_outlined,
              label: Text('[filtered]'),
            ),
          ),
        ),
        ...[
          if (item.isDeleted)
            Hero(
              tag: 'item_tile_deleted_${item.id}',
              child: MetadataWidget(
                icon: Icons.delete_outlined,
                label: Text(context.l10n.deleted),
              ),
            ),
          if (item.username case final username?) ...[
            Expanded(
              child: Hero(
                tag: 'item_tile_username_${item.id}',
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: UsernameWidget(
                    username: username,
                    showAvatar: showUserAvatars,
                    style: usernameStyle,
                    onTap: () async => context.push(
                      AppRoute.user.location(parameters: {'id': username}),
                    ),
                  ),
                ),
              ),
            ),
            if (item.hasUsernameTag)
              Hero(
                tag: 'item_tile_username_tag_${item.id}',
                child: Badge(
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  label: Text(item.usernameTag(context)!),
                ),
              ),
          ] else
            const Spacer(),
          if (failed)
            Hero(
              tag: 'item_tile_failed_${item.id}',
              child: const MetadataWidget(icon: Icons.error_outline_outlined),
            ),
          if (item.dateTime case final dateTime?)
            Hero(
              tag: 'item_tile_date_${item.id}',
              child: MetadataWidget(
                label: Tooltip(
                  message: dateTime.toString(),
                  child: Text(dateTime.relativeTime(context)),
                ),
              ),
            ),
        ].spaced(width: AppSpacing.m),
      ],
    );
  }

  Widget _buildFavoritedMetadata(BuildContext context) => MetadataWidget(
        icon: Icons.favorite_outline_outlined,
        color: favorited ? Theme.of(context).colorScheme.tertiary : null,
      );

  Widget _buildVotedMetadata(BuildContext context) => MetadataWidget(
        icon: vote.downvoted
            ? Icons.arrow_downward_outlined
            : Icons.arrow_upward_outlined,
        label: item.score != null ? Text(item.score!.toString()) : null,
        color: vote.downvoted
            ? Theme.of(context).colorScheme.secondary
            : vote.upvoted
                ? Theme.of(context).colorScheme.tertiary
                : null,
      );

  Widget _buildSecondary(BuildContext context) {
    return Column(
      children: [
        if (item.text case final text?)
          Hero(
            tag: 'item_tile_text_${item.id}',
            child: HackerNewsText(
              text,
              parsedData: parsedText,
              useInAppBrowser: useInAppBrowser,
            ),
          ),
        if (item.url case final url?)
          DecoratedCard.outlined(
            onTap: () async => url.tryLaunch(
              context,
              useInAppBrowser: useInAppBrowser,
            ),
            // Explicitly override parent widget's long press.
            onLongPress: () {},
            child: Row(
              children: [
                if (showFavicons)
                  Hero(
                    tag: 'item_tile_favicon_${item.id}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: _ItemFavicon(
                        item,
                        storyLines: 1,
                        useLargeStoryStyle: false,
                      ),
                    ),
                  )
                else
                  const MetadataWidget(icon: Icons.link_outlined),
                Expanded(
                  child: Hero(
                    tag: 'item_tile_url_${item.id}',
                    child: Text(
                      item.url!.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ].spaced(width: AppSpacing.l),
            ),
          ),
      ].spaced(height: AppSpacing.m),
    );
  }
}

class _ItemTitle extends StatelessWidget {
  const _ItemTitle(
    this.item, {
    required this.storyLines,
    required this.useLargeStoryStyle,
    required this.style,
  });

  final Item item;
  final int storyLines;
  final bool useLargeStoryStyle;
  final ItemStyle style;

  int get maxLines =>
      storyLines >= 0 ? storyLines : (useLargeStoryStyle ? 3 : 2);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: useLargeStoryStyle
            ? Theme.of(context).textTheme.titleMedium
            : Theme.of(context).textTheme.titleSmall,
        children: [
          if (item.hasPrefix) ...[
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Badge(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                label: Text(item.prefix!),
              ),
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(text: item.filteredTitle),
          if (item.hasSuffix) ...[
            const TextSpan(text: ' '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Badge(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                label: Text(item.suffix!),
              ),
            ),
          ],
          if (item.hasOriginalDate) ...[
            const TextSpan(text: ' '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Badge(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                label: Text(item.originalDate!),
              ),
            ),
          ],
          if (item.hasYcBatch) ...[
            const TextSpan(text: ' '),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: Badge(
                backgroundColor:
                    Theme.of(context).colorScheme.tertiaryContainer,
                textColor: Theme.of(context).colorScheme.onTertiaryContainer,
                label: Text(item.ycBatch!),
              ),
            ),
          ],
          if (style.showUrlHost && useLargeStoryStyle)
            if (item.url case final url?) ...[
              const TextSpan(text: ' '),
              TextSpan(
                text: '(',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              TextSpan(
                text: url.host,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              TextSpan(
                text: ')',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          // Append zero-width space of title style to enforce height.
          const TextSpan(text: '\u200b'),
          if (storyLines >= 0)
            // `minLines` does not exist, so append newlines as a workaround.
            TextSpan(text: '\n' * (maxLines - 1)),
        ],
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ItemFavicon extends StatelessWidget {
  const _ItemFavicon(
    this.item, {
    required this.storyLines,
    required this.useLargeStoryStyle,
  });

  final Item item;
  final int storyLines;
  final bool useLargeStoryStyle;

  int get _faviconSize => min(
        useLargeStoryStyle ? (storyLines >= 0 ? storyLines : 2) * 24 : 20,
        _faviconRequestSize,
      );

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: ResizeImage(
        NetworkImage(
          item.faviconUrl(size: _faviconRequestSize)!,
        ),
        width: _faviconSize,
        height: _faviconSize,
        policy: ResizeImagePolicy.fit,
      ),
      width: _faviconSize.toDouble(),
      height: _faviconSize.toDouble(),
    );
  }
}

class _MetadataActionButton extends StatelessWidget {
  const _MetadataActionButton({
    this.padding = EdgeInsets.zero,
    this.onTap,
    required this.child,
  });

  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          minimumSize: const Size.square(40),
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child,
      ),
    );
  }
}
