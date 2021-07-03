import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/models/slidable_action.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/reply_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/slidable.dart';
import 'package:glider/widgets/items/item_bottom_sheet.dart';
import 'package:glider/widgets/items/item_tile_content.dart';
import 'package:glider/widgets/items/item_tile_content_poll_option.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';

AutoDisposeStateProviderFamily<bool?, int> delayedUpvoteStateProvider =
    StateProvider.family.autoDispose((ProviderReference ref, int id) => null);

class ItemTileData extends HookWidget {
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
  Widget build(BuildContext context) {
    final bool active = item.deleted != true && item.localOnly != true;
    final Widget content = fadeable
        ? _buildFadeable(child: _buildContent(context))
        : _buildContent(context);

    return _buildSlidable(
      context,
      active: active,
      child: _buildIndented(
        child: active ? _buildTappable(context, child: content) : content,
      ),
    );
  }

  Widget _buildSlidable(BuildContext context,
      {required Widget child, required bool active}) {
    final bool canVote =
        active && item.type != ItemType.job && item.type != ItemType.pollopt;
    final bool canReply = canVote && root?.id != null;

    // We don't want the slidable to update while being slided, so we delay any
    // upvote state until after the call has actually finished.
    final StateController<bool?> delayedUpvotedController =
        useProvider(delayedUpvoteStateProvider(item.id));

    Future<void> updateDelayedUpvoted() async {
      final bool upvoted = await context.read(upvotedProvider(item.id).future);

      if (delayedUpvotedController.mounted) {
        delayedUpvotedController.state = upvoted;
      }
    }

    Future<void> vote({required bool up}) async {
      await _vote(context, up: up);
      unawaited(updateDelayedUpvoted());
    }

    useMemoized(updateDelayedUpvoted);

    return Slidable(
      key: ValueKey<int>(item.id),
      startToEndAction: canVote && delayedUpvotedController.state != null
          ? delayedUpvotedController.state != true
              ? SlidableAction(
                  action: () async {
                    unawaited(vote(up: true));
                  },
                  icon: FluentIcons.arrow_up_24_regular,
                  color: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.onPrimary,
                )
              : SlidableAction(
                  action: () async {
                    unawaited(vote(up: false));
                  },
                  icon: FluentIcons.arrow_undo_24_regular,
                )
          : null,
      endToStartAction: dense
          ? item.url != null
              ? SlidableAction(
                  action: () async {
                    unawaited(UrlUtil.tryLaunch(context, item.url!));
                  },
                  icon: FluentIcons.window_arrow_up_24_regular,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null
          : canReply
              ? SlidableAction(
                  action: () async {
                    unawaited(_reply(context));
                  },
                  icon: FluentIcons.arrow_reply_24_regular,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null,
      child: child,
    );
  }

  Widget _buildIndented({required Widget child}) {
    final int indentation =
        item.type != ItemType.pollopt ? item.ancestors.length : 0;
    final double indentationPadding = indentation.toDouble() * 8;

    Color _determineDividerColor() {
      final List<Color> colors = AppTheme.themeColors.toList(growable: false);
      final Color? themeColor = useProvider(themeColorProvider).data?.value;
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
                  color: _determineDividerColor(),
                ),
              ),
            ],
          )
        : child;
  }

  Widget _buildTappable(BuildContext context, {required Widget child}) {
    return InkWell(
      onTap: item.type == ItemType.pollopt && interactive
          ? () => _vote(
                context,
                up: !context.read(upvotedProvider(item.id)).maybeWhen(
                      data: (bool upvoted) => upvoted,
                      orElse: () => false,
                    ),
              )
          : onTap,
      onLongPress: () => _buildModalBottomSheet(context),
      child: child,
    );
  }

  Widget _buildFadeable({required Widget child}) {
    final bool visibility =
        useProvider(visitedProvider(item.id)).data?.value ?? false;

    return AnimatedOpacity(
      duration: AnimationUtil.defaultDuration,
      opacity: visibility ? 2 / 3 : 1,
      child: child,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (item.type == ItemType.pollopt) {
      return ItemTileContentPollOption(
        item,
        root: root,
        interactive: interactive,
        vote: _vote,
      );
    } else {
      return ItemTileContent(
        item,
        root: root,
        dense: dense,
        interactive: interactive,
      );
    }
  }

  Future<void> _buildModalBottomSheet(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => ItemBottomSheet(item),
    );
  }

  Future<void> _vote(BuildContext context, {required bool up}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await authRepository.vote(
        id: item.id,
        up: up,
        onUpdate: () => context.refresh(upvotedProvider(item.id)),
      );

      if (success) {
        final int? score = item.score;
        if (score != null) {
          context.read(itemCacheStateProvider(item.id)).state =
              item.copyWith(score: score + (up ? 1 : -1));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBarQuickly(
          const SnackBar(content: Text('Something went wrong')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(
          content: const Text('Log in to vote'),
          action: SnackBarAction(
            label: 'Log in',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const AccountPage(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _reply(BuildContext context) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => ReplyPage(parent: item, root: root),
              fullscreenDialog: true,
            ),
          ) ??
          false;

      final int? rootId = root?.id;

      if (success && rootId != null) {
        context.refresh(itemTreeStreamProvider(rootId));
        ScaffoldMessenger.of(context).showSnackBarQuickly(
          SnackBar(
            content: const Text(
              'Processing may take a moment, '
              'consider refreshing for an updated view',
            ),
            action: SnackBarAction(
              label: 'Refresh',
              onPressed: () async {
                await reloadItemTree(context.refresh, id: rootId);
                return context.refresh(itemTreeStreamProvider(rootId));
              },
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(
          content: const Text('Log in to reply'),
          action: SnackBarAction(
            label: 'Log in',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const AccountPage(),
              ),
            ),
          ),
        ),
      );
    }
  }
}
