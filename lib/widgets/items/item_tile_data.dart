import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/commands/reply_command.dart';
import 'package:glider/commands/vote_command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/models/slidable_action.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/indented_tile.dart';
import 'package:glider/widgets/common/slidable.dart';
import 'package:glider/widgets/items/item_bottom_sheet.dart';
import 'package:glider/widgets/items/item_tile_content.dart';
import 'package:glider/widgets/items/item_tile_content_poll_option.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

AutoDisposeStateProviderFamily<bool?, int> _delayedUpvoteStateProvider =
    StateProvider.family.autoDispose(
  (AutoDisposeStateProviderRef<bool?> ref, int id) => null,
);

class ItemTileData extends HookConsumerWidget {
  const ItemTileData(
    this.item, {
    super.key,
    this.root,
    this.onTap,
    this.dense = false,
    this.interactive = false,
    this.fadeable = false,
  });

  final Item item;
  final Item? root;
  final void Function()? onTap;
  final bool dense;
  final bool interactive;
  final bool fadeable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget child = _buildContent(context, ref);
    child = _buildTappable(context, ref, child: child);
    child = _buildIndented(ref, child: child);
    child = _buildSlidable(context, ref, child: child);
    return child;
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final double opacity =
        fadeable && (ref.watch(visitedProvider(item.id)).value ?? false)
            ? 2 / 3
            : 1;

    if (item.type == ItemType.pollopt) {
      return ItemTileContentPollOption(
        item,
        root: root,
        interactive: interactive,
        opacity: opacity,
      );
    } else {
      return ItemTileContent(
        item,
        root: root,
        dense: dense,
        interactive: interactive,
        opacity: opacity,
      );
    }
  }

  Widget _buildTappable(BuildContext context, WidgetRef ref,
      {required Widget child}) {
    if (!item.active) {
      return child;
    }

    return InkWell(
      onTap: item.type == ItemType.pollopt && interactive
          ? () => VoteCommand(
                context,
                ref,
                id: item.id,
                upvote: !ref.read(upvotedProvider(item.id)).maybeWhen(
                      data: (bool upvoted) => upvoted,
                      orElse: () => false,
                    ),
              ).execute()
          : onTap,
      onLongPress: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => ItemBottomSheet(id: item.id),
      ),
      child: child,
    );
  }

  Widget _buildIndented(WidgetRef ref, {required Widget child}) {
    final int indentation =
        item.type != ItemType.pollopt ? item.indentation : 0;

    return IndentedTile(indentation: indentation, child: child);
  }

  Widget _buildSlidable(BuildContext context, WidgetRef ref,
      {required Widget child}) {
    if (!(ref.watch(useGesturesProvider).value ?? true)) {
      return child;
    }

    // We don't want the slidable to update while being slided, so we delay any
    // upvote state until after the call has actually finished.
    final StateController<bool?> delayedUpvotedController =
        ref.watch(_delayedUpvoteStateProvider(item.id).state);

    Future<void> updateDelayedUpvoted() async {
      final bool upvoted = await ref.read(upvotedProvider(item.id).future);

      if (delayedUpvotedController.mounted) {
        delayedUpvotedController.update((_) => upvoted);
      }
    }

    Future<void> vote({required bool upvote}) async {
      unawaited(
        VoteCommand(context, ref, id: item.id, upvote: upvote).execute(),
      );
      Future<void>.delayed(Slidable.movementDuration, updateDelayedUpvoted);
    }

    useMemoized(updateDelayedUpvoted);

    return Slidable(
      key: ValueKey<String>('item_${item.id}_slidable'),
      startToEndAction: item.votable && delayedUpvotedController.state != null
          ? delayedUpvotedController.state != true
              ? SlidableAction(
                  action: () async {
                    unawaited(vote(upvote: true));
                    return false;
                  },
                  icon: FluentIcons.arrow_up_24_regular,
                  color: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.onPrimary,
                )
              : SlidableAction(
                  action: () async {
                    unawaited(vote(upvote: false));
                    return false;
                  },
                  icon: FluentIcons.arrow_undo_24_regular,
                )
          : null,
      endToStartAction: dense
          ? item.url != null
              ? SlidableAction(
                  action: () async {
                    unawaited(UrlUtil.tryLaunch(context, ref, item.url!));
                    return false;
                  },
                  icon: FluentIcons.window_arrow_up_24_regular,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null
          : item.replyable
              ? SlidableAction(
                  action: () async {
                    unawaited(
                      ReplyCommand(context, ref, id: item.id, rootId: root?.id)
                          .execute(),
                    );
                    return false;
                  },
                  icon: FluentIcons.arrow_reply_24_regular,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null,
      child: child,
    );
  }
}
