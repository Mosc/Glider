import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/commands/reply_command.dart';
import 'package:glider/commands/vote_command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_menu_action.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/models/slidable_action.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/menu_actions_bar.dart';
import 'package:glider/widgets/common/slidable.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_content.dart';
import 'package:glider/widgets/items/item_tile_content_poll_option.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

AutoDisposeStateProviderFamily<bool?, int> _delayedUpvoteStateProvider =
    StateProvider.family.autoDispose(
  (AutoDisposeStateProviderRef<bool?> ref, int id) => null,
);

StateProviderFamily<bool, int> _longPressStateProvider = StateProvider.family(
  (StateProviderRef<bool> ref, int id) => false,
);

class ItemTileData extends HookConsumerWidget {
  const ItemTileData(
    this.item, {
    Key? key,
    this.root,
    this.onTap,
    this.dense = false,
    this.interactive = false,
    this.fadeable = false,
  }) : super(key: key);

  final Item item;
  final Item? root;
  final void Function()? onTap;
  final bool dense;
  final bool interactive;
  final bool fadeable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool active = item.deleted != true && item.preview != true;
    final Widget content = Column(
      children: <Widget>[
        _buildContent(context, ref),
        SmoothAnimatedSwitcher.vertical(
          condition: ref.watch(_longPressStateProvider(item.id)),
          child: MenuActionsBar(
            children: <IconButton>[
              for (ItemMenuAction menuAction in ItemMenuAction.values)
                if (menuAction.visible(context, ref, id: item.id))
                  IconButton(
                    icon: Icon(menuAction.icon(context, ref, id: item.id)),
                    tooltip: menuAction.title(context, ref, id: item.id),
                    onPressed: () => menuAction
                        .command(context, ref, id: item.id, rootId: root?.id)
                        .execute(),
                  ),
            ],
          ),
        ),
      ],
    );

    return _buildSlidable(
      context,
      ref,
      active: active,
      child: _buildIndented(
        ref,
        child: active ? _buildTappable(context, ref, child: content) : content,
      ),
    );
  }

  Widget _buildSlidable(BuildContext context, WidgetRef ref,
      {required Widget child, required bool active}) {
    // We don't want the slidable to update while being slided, so we delay any
    // upvote state until after the call has actually finished.
    final StateController<bool?> delayedUpvotedController =
        ref.watch(_delayedUpvoteStateProvider(item.id).state);
    final bool useGestures =
        ref.watch(useGesturesProvider).asData?.value ?? true;

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
      startToEndAction: active &&
              item.type != ItemType.job &&
              delayedUpvotedController.state != null
          ? delayedUpvotedController.state != true
              ? SlidableAction(
                  action: () async {
                    unawaited(vote(upvote: true));
                  },
                  icon: FluentIcons.arrow_up_24_regular,
                  color: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.onPrimary,
                )
              : SlidableAction(
                  action: () async {
                    unawaited(vote(upvote: false));
                  },
                  icon: FluentIcons.arrow_undo_24_regular,
                )
          : null,
      endToStartAction: dense
          ? item.url != null
              ? SlidableAction(
                  action: () async {
                    unawaited(UrlUtil.tryLaunch(context, ref, item.url!));
                  },
                  icon: FluentIcons.window_arrow_up_24_regular,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null
          : active && item.type != ItemType.job && item.type != ItemType.pollopt
              ? SlidableAction(
                  action: () async {
                    unawaited(
                      ReplyCommand(context, ref, id: item.id, rootId: root?.id)
                          .execute(),
                    );
                  },
                  icon: FluentIcons.arrow_reply_24_regular,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null,
      useGestures: useGestures,
      child: child,
    );
  }

  Widget _buildIndented(WidgetRef ref, {required Widget child}) {
    final int indentation =
        item.type != ItemType.pollopt ? item.indentation : 0;
    final double indentationPadding = indentation.toDouble() * 8;

    Color _determineDividerColor(WidgetRef ref) {
      final List<Color> colors = AppTheme.themeColors.toList(growable: false);
      final Color? themeColor = ref.watch(themeColorProvider).asData?.value;
      final int initialOffset =
          themeColor != null ? colors.indexOf(themeColor) : 0;
      final int offset =
          (initialOffset + (indentation - 1) * 2) % colors.length;
      return colors[offset];
    }

    return indentation > 0
        ? Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: indentationPadding),
                child: child,
              ),
              PositionedDirectional(
                start: indentationPadding - 1,
                top: 4,
                bottom: 4,
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: _determineDividerColor(ref),
                ),
              ),
            ],
          )
        : child;
  }

  Widget _buildTappable(BuildContext context, WidgetRef ref,
      {required Widget child}) {
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
      onLongPress: () => ref
          .read(_longPressStateProvider(item.id).state)
          .update((bool state) => !state),
      child: child,
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final double opacity =
        fadeable && (ref.watch(visitedProvider(item.id)).asData?.value ?? false)
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
}
