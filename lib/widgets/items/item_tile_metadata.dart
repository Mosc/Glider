import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/fade_hero.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/metadata_username.dart';
import 'package:glider/widgets/common/smooth_animated_size.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileMetadata extends HookConsumerWidget {
  const ItemTileMetadata(
    this.item, {
    Key? key,
    this.root,
    this.dense = false,
    this.interactive = false,
  }) : super(key: key);

  final Item item;
  final Item? root;
  final bool dense;
  final bool interactive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final AsyncData<bool>? favoritedData =
        ref.watch(favoritedProvider(item.id)).asData;
    final AsyncData<bool>? upvotedData =
        ref.watch(upvotedProvider(item.id)).asData;

    return FadeHero(
      tag: 'item_${item.id}_metadata',
      child: Row(
        children: <Widget>[
          if (favoritedData != null)
            SmoothAnimatedSwitcher.horizontal(
              condition: favoritedData.value,
              child: const MetadataItem(
                icon: FluentIcons.star_24_regular,
                highlight: true,
              ),
            ),
          if (item.score != null && item.type != ItemType.job)
            SmoothAnimatedSize(
              child: _buildUpvotedMetadata(
                upvoted: upvotedData?.value ?? false,
              ),
            )
          else if (upvotedData != null)
            SmoothAnimatedSwitcher.horizontal(
              condition: upvotedData.value,
              child: _buildUpvotedMetadata(upvoted: upvotedData.value),
            ),
          if (item.descendants != null)
            SmoothAnimatedSize(
              child: MetadataItem(
                icon: FluentIcons.comment_24_regular,
                text: item.descendants?.toString(),
              ),
            ),
          SmoothAnimatedSwitcher.horizontal(
            key: ValueKey<String>('item_${item.id}_dead_${item.dead}'),
            condition: item.dead ?? false,
            child: const MetadataItem(icon: FluentIcons.flag_24_regular),
          ),
          if (item.deleted ?? false) ...<Widget>[
            const MetadataItem(icon: FluentIcons.delete_24_regular),
            Text(
              '[${AppLocalizations.of(context).deleted}]',
              style: textTheme.bodyText2
                  ?.copyWith(fontSize: textTheme.bodySmall?.fontSize),
            ),
            const SizedBox(width: 8),
          ] else if (item.by != null &&
              item.type != ItemType.pollopt) ...<Widget>[
            MetadataUsername(username: item.by!, rootUsername: root?.by),
            const SizedBox(width: 8),
          ],
          if (item.by != null &&
              (ref.watch(blockedProvider(item.by!)).value ??
                  false)) ...<Widget>[
            Text(
              '[${AppLocalizations.of(context).blocked}]',
              style: textTheme.bodyText2
                  ?.copyWith(fontSize: textTheme.bodySmall?.fontSize),
            ),
            const SizedBox(width: 8),
          ],
          if (item.hasOriginalYear)
            MetadataItem(
              icon: FluentIcons.shifts_activity_24_regular,
              text: AppLocalizations.of(context).fromYear(item.originalYear!),
            ),
          SmoothAnimatedSwitcher.horizontal(
            condition: item.cache,
            child: const MetadataItem(icon: FluentIcons.cloud_off_24_regular),
          ),
          if (interactive) _buildCollapsedIndicator(),
          if (item.type != ItemType.pollopt && item.time != null) ...<Widget>[
            const Spacer(),
            Text(item.timeAgo!, style: textTheme.bodySmall),
          ],
        ],
      ),
    );
  }

  Widget _buildUpvotedMetadata({required bool upvoted}) {
    return MetadataItem(
      key: ValueKey<String>('item_${item.id}_score_${item.score}'),
      icon: FluentIcons.arrow_up_24_regular,
      text: item.score?.toString(),
      highlight: upvoted,
    );
  }

  Widget _buildCollapsedIndicator() {
    return SmoothAnimatedSwitcher(
      condition: dense,
      child: MetadataItem(
        icon: FluentIcons.add_circle_24_regular,
        text: item.kids.isNotEmpty && item.id != root?.id
            ? item.kids.length.toString()
            : null,
      ),
    );
  }
}
