import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/widgets/common/fade_hero.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';
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
    this.opacity = 1,
  }) : super(key: key);

  final Item item;
  final Item? root;
  final bool dense;
  final bool interactive;
  final double opacity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final TextTheme textTheme = Theme.of(context).textTheme;

    final AsyncData<bool>? favoritedData =
        ref.watch(favoritedProvider(item.id)).data;
    final AsyncData<bool>? upvotedData =
        ref.watch(upvotedProvider(item.id)).data;

    return FadeHero(
      tag: 'item_${item.id}_metadata',
      child: AnimatedOpacity(
        opacity: opacity,
        duration: AnimationUtil.defaultDuration,
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
              SmoothAnimatedCrossFade(
                condition: upvotedData?.value ?? false,
                trueChild: _buildUpvotedMetadata(upvoted: true),
                falseChild: _buildUpvotedMetadata(upvoted: false),
              )
            else if (upvotedData != null)
              SmoothAnimatedSwitcher.horizontal(
                condition: upvotedData.value,
                child: _buildUpvotedMetadata(upvoted: true),
              ),
            if (item.descendants != null)
              SmoothAnimatedSize(
                child: MetadataItem(
                  key: ValueKey<String>(
                      'item_${item.id}_descendants_${item.descendants}'),
                  icon: FluentIcons.comment_24_regular,
                  text: item.descendants.toString(),
                ),
              ),
            SmoothAnimatedSwitcher.horizontal(
              condition: item.dead ?? false,
              child: const MetadataItem(icon: FluentIcons.flag_24_regular),
            ),
            if (item.deleted ?? false) ...<Widget>[
              const MetadataItem(icon: FluentIcons.delete_24_regular),
              Text(
                '[${appLocalizations.deleted}]',
                style: textTheme.bodyText2
                    ?.copyWith(fontSize: textTheme.caption?.fontSize),
              ),
            ] else if (item.by != null &&
                item.type != ItemType.pollopt) ...<Widget>[
              _buildUsername(context, ref, textTheme,
                  by: item.by!, rootBy: root?.by),
              const SizedBox(width: 8),
            ],
            if (item.hasOriginalYear)
              MetadataItem(
                icon: FluentIcons.shifts_activity_24_regular,
                text: appLocalizations.fromYear(item.originalYear!),
              ),
            SmoothAnimatedSwitcher.horizontal(
              condition: item.cache,
              child: const MetadataItem(
                  icon: FluentIcons.cloud_offline_24_regular),
            ),
            if (interactive) _buildCollapsedIndicator(),
            if (item.type != ItemType.pollopt && item.time != null) ...<Widget>[
              const Spacer(),
              Text(item.timeAgo!, style: textTheme.caption),
            ],
          ],
        ),
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

  Widget _buildUsername(
      BuildContext context, WidgetRef ref, TextTheme textTheme,
      {required String by, String? rootBy}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool byLoggedInUser =
        item.by == ref.watch(usernameProvider).data?.value;
    final bool byRoot = item.by == rootBy;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => UserPage(id: by),
        ),
      ),
      child: byLoggedInUser || byRoot
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: byLoggedInUser ? colorScheme.primary : null,
                border: Border.all(color: colorScheme.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                by,
                style: textTheme.caption?.copyWith(
                  color: byLoggedInUser
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                by,
                style: textTheme.caption?.copyWith(color: colorScheme.primary),
              ),
            ),
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
