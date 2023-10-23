import 'dart:math';

import 'package:flutter/material.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/common/constants/app_animation.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/uri_extension.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/widgets/animated_visibility.dart';
import 'package:glider/common/widgets/decorated_card.dart';
import 'package:glider/common/widgets/hacker_news_text.dart';
import 'package:glider/common/widgets/metadata_widget.dart';
import 'package:glider/item/extensions/item_extension.dart';
import 'package:glider/item/models/item_style.dart';
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
    this.visited = false,
    this.upvoted = false,
    this.favorited = false,
    this.flagged = false,
    this.blocked = false,
    this.cached = false,
    this.collapsedCount,
    this.useLargeStoryStyle = true,
    this.showMetadata = true,
    this.style = ItemStyle.full,
    this.usernameStyle = UsernameStyle.none,
    this.padding = AppSpacing.defaultTilePadding,
    this.onTap,
    this.onLongPress,
  });

  final Item item;
  final bool visited;
  final bool upvoted;
  final bool favorited;
  final bool flagged;
  final bool blocked;
  final bool cached;
  final int? collapsedCount;
  final bool useLargeStoryStyle;
  final bool showMetadata;
  final ItemStyle style;
  final UsernameStyle usernameStyle;
  final EdgeInsets padding;
  final ItemCallback? onTap;
  final ItemCallback? onLongPress;

  int get _faviconSize =>
      min(useLargeStoryStyle ? 2 * 24 : 20, _faviconRequestSize);

  @override
  Widget build(BuildContext context) {
    if (item.type == ItemType.pollopt) {
      return SwitchListTile.adaptive(
        value: upvoted,
        onChanged: (value) => onTap?.call(context, item),
        title: Row(
          children: [
            if (item.text case final text?)
              Expanded(
                child: HackerNewsText(text),
              )
            else
              const Spacer(),
            MetadataWidget(
              icon: Icons.arrow_upward_outlined,
              label: item.score != null ? Text(item.score!.toString()) : null,
              color: upvoted ? Theme.of(context).colorScheme.tertiary : null,
            ),
          ].spaced(width: AppSpacing.s),
        ),
        contentPadding: padding.copyWith(top: 0, bottom: 0),
        visualDensity: VisualDensity.compact,
      );
    }

    final hasPrimary = style.showPrimary &&
        item.dateTime != null &&
        (showMetadata || (item.title != null || item.url != null) && !blocked);
    final hasSecondary = style.showSecondary &&
        (item.text != null || item.url != null) &&
        !blocked;

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
          opacity: visited ? 0.75 : 1,
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: AppAnimation.emphasized.duration,
            curve: AppAnimation.emphasized.easing,
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
      ),
    );
  }

  Widget _buildPrimary(BuildContext context) {
    return Column(
      children: [
        if ((item.title != null || item.url != null) && !blocked)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.title case final _?)
                Expanded(
                  child: _ItemTitle(
                    item,
                    useLargeStoryStyle: useLargeStoryStyle,
                    style: style,
                  ),
                )
              else
                const Spacer(),
              if (item.url case final url?)
                Hero(
                  tag: 'item_tile_favicon_${item.id}',
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onTap: () async => url.tryLaunch(),
                      // Explicitly override parent widget's long press.
                      onLongPress: () {},
                      child: Ink.image(
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
                      ),
                    ),
                  ),
                ),
            ].spaced(width: AppSpacing.xl),
          ),
        if (showMetadata)
          Row(
            children: [
              AnimatedVisibility(
                visible: collapsedCount != null,
                padding: MetadataWidget.horizontalPadding,
                child: Hero(
                  tag: 'item_tile_collapsed_${item.id}',
                  child: MetadataWidget(
                    icon: Icons.add_circle_outline_outlined,
                    label: collapsedCount != null && collapsedCount! > 0
                        ? Text(collapsedCount.toString())
                        : null,
                  ),
                ),
              ),
              AnimatedVisibility(
                visible: favorited,
                padding: MetadataWidget.horizontalPadding,
                child: Hero(
                  tag: 'item_tile_favorited_${item.id}',
                  child: MetadataWidget(
                    icon: Icons.favorite_outline_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              AnimatedVisibility(
                visible:
                    item.score != null && item.type != ItemType.job || upvoted,
                padding: MetadataWidget.horizontalPadding,
                child: Hero(
                  tag: 'item_tile_score_${item.id}',
                  child: MetadataWidget(
                    icon: Icons.arrow_upward_outlined,
                    label: item.score != null
                        ? Text((item.score!).toString())
                        : null,
                    color:
                        upvoted ? Theme.of(context).colorScheme.tertiary : null,
                  ),
                ),
              ),
              AnimatedVisibility(
                visible: item.descendantCount != null,
                padding: MetadataWidget.horizontalPadding,
                child: Hero(
                  tag: 'item_tile_descendants_${item.id}',
                  child: MetadataWidget(
                    icon: Icons.mode_comment_outlined,
                    label: item.descendantCount != null
                        ? Text(item.descendantCount!.toString())
                        : null,
                  ),
                ),
              ),
              AnimatedVisibility(
                visible: item.isDead || flagged,
                padding: MetadataWidget.horizontalPadding,
                child: Hero(
                  tag: 'item_tile_dead_${item.id}',
                  child: MetadataWidget(
                    icon: Icons.flag_outlined,
                    color:
                        flagged ? Theme.of(context).colorScheme.tertiary : null,
                  ),
                ),
              ),
              AnimatedVisibility(
                visible: blocked,
                padding: MetadataWidget.horizontalPadding,
                child: Hero(
                  tag: 'item_tile_blocked_${item.id}',
                  child: MetadataWidget(
                    icon: Icons.block_outlined,
                    label: Text(context.l10n.blocked),
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
                          style: usernameStyle,
                          onTap: () async => context.push(
                            AppRoute.user
                                .location(parameters: {'id': username}),
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
                        textColor:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        label: Text(item.usernameTag(context)!),
                      ),
                    ),
                ] else
                  const Spacer(),
                if (cached)
                  Hero(
                    tag: 'item_tile_stale_${item.id}',
                    child: const MetadataWidget(icon: Icons.cached_outlined),
                  ),
                if (item.dateTime case final dateTime?)
                  Hero(
                    tag: 'item_tile_date_${item.id}',
                    child: MetadataWidget(
                      label: Tooltip(
                        message: dateTime.toString(),
                        child: Text(item.dateTime!.relativeTime(context)),
                      ),
                    ),
                  ),
              ].spaced(width: AppSpacing.m),
            ],
          ),
      ].spaced(height: AppSpacing.m),
    );
  }

  Widget _buildSecondary(BuildContext context) {
    return Hero(
      tag: 'item_tile_secondary_${item.id}',
      child: Column(
        children: [
          if (item.text case final text?) HackerNewsText(text),
          if (item.url case final url?)
            DecoratedCard.outlined(
              onTap: () async => url.tryLaunch(),
              // Explicitly override parent widget's long press.
              onLongPress: () {},
              child: Row(
                children: [
                  const MetadataWidget(icon: Icons.link_outlined),
                  Expanded(
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
                ].spaced(width: AppSpacing.l),
              ),
            ),
        ].spaced(height: AppSpacing.m),
      ),
    );
  }
}

class _ItemTitle extends StatelessWidget {
  const _ItemTitle(
    this.item, {
    required this.useLargeStoryStyle,
    required this.style,
  });

  final Item item;
  final bool useLargeStoryStyle;
  final ItemStyle style;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'item_tile_title_${item.id}',
      child: Text.rich(
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
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
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
                // Attach zero-width space of title style to
                // enforce height.
                const TextSpan(text: '\u200b'),
              ],
            if (useLargeStoryStyle) const TextSpan(text: '\n'),
          ],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
