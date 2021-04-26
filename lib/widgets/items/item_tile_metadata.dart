import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';
import 'package:glider/widgets/common/smooth_animated_size.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileMetadata extends HookWidget {
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
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AsyncData<bool>? favorited =
        useProvider(favoritedProvider(item.id)).data;
    final AsyncData<bool>? upvoted = useProvider(upvotedProvider(item.id)).data;

    return Hero(
      tag: 'item_metadata_${item.id}',
      child: Row(
        children: <Widget>[
          if (favorited != null)
            SmoothAnimatedSwitcher.horizontal(
              condition: favorited.value,
              child: const MetadataItem(
                icon: FluentIcons.star_24_regular,
                highlight: true,
              ),
            ),
          if (item.score != null)
            SmoothAnimatedCrossFade(
              condition: upvoted?.value ?? false,
              trueChild: _buildUpvotedMetadata(upvoted: true),
              falseChild: _buildUpvotedMetadata(upvoted: false),
            )
          else if (upvoted != null)
            SmoothAnimatedSwitcher.horizontal(
              condition: upvoted.value,
              child: _buildUpvotedMetadata(upvoted: true),
            ),
          if (item.descendants != null)
            SmoothAnimatedSize(
              child: MetadataItem(
                key: ValueKey<int?>(item.descendants),
                icon: FluentIcons.comment_24_regular,
                text: item.descendants.toString(),
              ),
            ),
          if (item.dead ?? false)
            const MetadataItem(icon: FluentIcons.flag_24_regular),
          if (item.deleted ?? false) ...<Widget>[
            const MetadataItem(icon: FluentIcons.delete_24_regular),
            Text(
              '[deleted]',
              style: textTheme.bodyText2
                  ?.copyWith(fontSize: textTheme.caption?.fontSize),
            ),
          ] else if (item.by != null &&
              item.type != ItemType.pollopt) ...<Widget>[
            _buildUsername(context, textTheme, by: item.by!, rootBy: root?.by),
            const SizedBox(width: 8),
          ],
          if (item.hasOriginalYear)
            MetadataItem(
              icon: FluentIcons.shifts_activity_24_regular,
              text: 'from ${item.originalYear}',
            ),
          if (interactive) _buildCollapsedIndicator(),
          if (item.type != ItemType.pollopt && item.time != null) ...<Widget>[
            const Spacer(),
            Text(item.timeAgo!, style: textTheme.caption),
          ],
        ],
      ),
    );
  }

  Widget _buildUpvotedMetadata({required bool upvoted}) {
    return MetadataItem(
      key: ValueKey<int?>(item.score),
      icon: FluentIcons.arrow_up_24_regular,
      text: item.score?.toString(),
      highlight: upvoted,
    );
  }

  Widget _buildUsername(BuildContext context, TextTheme textTheme,
      {required String by, String? rootBy}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool byLoggedInUser =
        item.by == useProvider(usernameProvider).data?.value;
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
