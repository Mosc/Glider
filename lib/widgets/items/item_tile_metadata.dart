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
          if (item.dead == true)
            const MetadataItem(icon: FluentIcons.flag_24_regular),
          if (item.deleted == true) ...<Widget>[
            const MetadataItem(icon: FluentIcons.delete_24_regular),
            Text(
              '[deleted]',
              style: textTheme.bodyText2
                  ?.copyWith(fontSize: textTheme.caption?.fontSize),
            ),
          ] else if (item.by != null &&
              item.type != ItemType.pollopt) ...<Widget>[
            if (item.by == root?.by && item.parent != null)
              const MetadataItem(icon: FluentIcons.person_circle_20_regular),
            _buildUsername(context, textTheme, by: item.by!),
            const SizedBox(width: 8),
          ],
          if (item.hasOriginalYear == true)
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
      {required String by}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => UserPage(id: by),
        ),
      ),
      child: item.by == useProvider(usernameProvider).data?.value
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                by,
                style: textTheme.caption
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                by,
                style: textTheme.caption
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
    );
  }

  Widget _buildCollapsedIndicator() {
    return SmoothAnimatedSwitcher(
      condition: dense,
      child: MetadataItem(
        icon: FluentIcons.add_circle_24_regular,
        text: item.id != root?.id ? item.kids.length.toString() : null,
      ),
    );
  }
}
