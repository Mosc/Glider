import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileMetadata extends HookWidget {
  const ItemTileMetadata(
    this.item, {
    Key key,
    this.root,
    this.dense = false,
    this.collapsible = false,
  }) : super(key: key);

  final Item item;
  final Item root;
  final bool dense;
  final bool collapsible;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Hero(
      tag: 'item_metadata_${item.id}',
      child: Row(
        children: <Widget>[
          useProvider(favoritedProvider(item.id)).maybeWhen(
            data: (bool favorited) => SmoothAnimatedSwitcher(
              axis: Axis.horizontal,
              condition: favorited,
              child: const MetadataItem(
                icon: FluentIcons.star_24_regular,
                highlight: true,
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          useProvider(upvotedProvider(item.id)).maybeWhen(
            data: (bool upvoted) => item.score != null
                ? SmoothAnimatedCrossFade(
                    condition: upvoted,
                    trueChild: _buildUpvotedMetadata(upvoted: true),
                    falseChild: _buildUpvotedMetadata(upvoted: false),
                  )
                : SmoothAnimatedSwitcher(
                    axis: Axis.horizontal,
                    condition: upvoted,
                    child: _buildUpvotedMetadata(upvoted: true),
                  ),
            orElse: () => _buildUpvotedMetadata(upvoted: false),
          ),
          if (item.descendants != null)
            MetadataItem(
              icon: FluentIcons.comment_24_regular,
              text: item.descendants.toString(),
            ),
          if (item.type == ItemType.job)
            const MetadataItem(icon: FluentIcons.briefcase_24_regular)
          else if (item.type == ItemType.poll)
            const MetadataItem(icon: FluentIcons.poll_24_regular),
          if (item.dead == true)
            const MetadataItem(icon: FluentIcons.flag_24_regular),
          if (item.deleted == true)
            const MetadataItem(
              icon: FluentIcons.delete_24_regular,
              text: '[deleted]',
            )
          else if (item.by != null && item.type != ItemType.pollopt)
            _buildUsername(context, textTheme),
          if (collapsible) _buildCollapsedIndicator(),
          const Spacer(),
          if (item.type != ItemType.pollopt)
            Text(item.timeAgo, style: textTheme.caption),
        ],
      ),
    );
  }

  Widget _buildUpvotedMetadata({@required bool upvoted}) {
    return MetadataItem(
      key: ValueKey<bool>(upvoted),
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
