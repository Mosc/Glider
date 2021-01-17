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
    Key key,
    this.root,
    this.dense = false,
    this.interactive = false,
  }) : super(key: key);

  final Item item;
  final Item root;
  final bool dense;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AsyncValue<bool> favorited = useProvider(favoritedProvider(item.id));
    final AsyncValue<bool> upvoted = useProvider(upvotedProvider(item.id));

    return Hero(
      tag: 'item_metadata_${item.id}',
      child: Row(
        children: <Widget>[
          if (favorited.data != null)
            SmoothAnimatedSwitcher(
              axis: Axis.horizontal,
              condition: favorited.data.value,
              child: const MetadataItem(
                icon: FluentIcons.star_24_regular,
                highlight: true,
              ),
            ),
          if (item.score != null)
            SmoothAnimatedCrossFade(
              condition: upvoted.data?.value ?? false,
              trueChild: _buildUpvotedMetadata(upvoted: true),
              falseChild: _buildUpvotedMetadata(upvoted: false),
            )
          else if (upvoted.data != null)
            SmoothAnimatedSwitcher(
              axis: Axis.horizontal,
              condition: upvoted.data.value,
              child: _buildUpvotedMetadata(upvoted: true),
            ),
          if (item.descendants != null)
            SmoothAnimatedSize(
              child: MetadataItem(
                key: ValueKey<int>(item.descendants),
                icon: FluentIcons.comment_24_regular,
                text: item.descendants.toString(),
              ),
            ),
          if (item.type == ItemType.job)
            const MetadataItem(icon: FluentIcons.briefcase_24_regular)
          else if (item.type == ItemType.poll)
            const MetadataItem(icon: FluentIcons.poll_24_regular),
          if (item.dead == true)
            const MetadataItem(icon: FluentIcons.flag_24_regular),
          if (item.deleted == true) ...<Widget>[
            const MetadataItem(icon: FluentIcons.delete_24_regular),
            Text(
              '[deleted]',
              style: textTheme.bodyText2
                  .copyWith(fontSize: textTheme.caption.fontSize),
            ),
          ] else if (item.by != null && item.type != ItemType.pollopt)
            _buildUsername(context, textTheme),
          if (interactive) _buildCollapsedIndicator(),
          if (item.type != ItemType.pollopt) ...<Widget>[
            const Spacer(),
            Text(item.timeAgo, style: textTheme.caption),
          ],
        ],
      ),
    );
  }

  Widget _buildUpvotedMetadata({@required bool upvoted}) {
    return MetadataItem(
      key: ValueKey<int>(item.score),
      icon: FluentIcons.arrow_up_24_regular,
      text: item.score?.toString(),
      highlight: upvoted,
    );
  }

  Widget _buildUsername(BuildContext context, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => UserPage(id: item.by),
        ),
      ),
      child: Row(children: <Widget>[
        if (item.by == root?.by)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.by,
              style: textTheme.caption
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text(
              item.by,
              style: textTheme.caption
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        const SizedBox(width: 8),
      ]),
    );
  }

  Widget _buildCollapsedIndicator() {
    return SmoothAnimatedSwitcher(
      transitionBuilder: SmoothAnimatedSwitcher.fadeTransitionBuilder,
      condition: dense,
      child: MetadataItem(
        icon: FluentIcons.add_circle_24_regular,
        text: item.id != root?.id ? item.kids?.length?.toString() : null,
      ),
    );
  }
}
