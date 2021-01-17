import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/models/slidable_action.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/reply_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/slidable.dart';
import 'package:glider/widgets/items/item_tile_content.dart';
import 'package:glider/widgets/items/item_tile_content_poll_option.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pedantic/pedantic.dart';
import 'package:share/share.dart';

AutoDisposeStateProviderFamily<bool, int> delayedUpvoteStateProvider =
    StateProvider.family.autoDispose((ProviderReference ref, int id) => null);

class ItemTileData extends HookWidget {
  const ItemTileData(
    this.item, {
    Key key,
    this.root,
    this.onTap,
    this.dense = false,
    this.interactive = false,
    this.fadeable = false,
  }) : super(key: key);

  final Item item;
  final Item root;
  final void Function() onTap;
  final bool dense;
  final bool interactive;
  final bool fadeable;

  @override
  Widget build(BuildContext context) {
    final bool indented =
        item.ancestors?.isNotEmpty == true && item.type != ItemType.pollopt;

    return Stack(
      children: <Widget>[
        if (indented)
          Positioned.fill(
            child: Row(
              children: <Widget>[
                for (int i = 0; i < item.ancestors.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: VerticalDivider(
                      width: 0,
                      color: i == item.ancestors.length - 1 &&
                              item.by != null &&
                              useProvider(usernameProvider).maybeWhen(
                                data: (String by) => by == item.by,
                                orElse: () => false,
                              )
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        Padding(
          padding: indented
              ? EdgeInsets.only(left: item.ancestors.length * 8.0)
              : EdgeInsets.zero,
          child: _buildSlidable(context),
        ),
      ],
    );
  }

  Widget _buildSlidable(BuildContext context) {
    final bool active =
        item.id != null && item.deleted != true && item.localOnly != true;
    final bool canVote =
        active && item.type != ItemType.job && item.type != ItemType.pollopt;
    final bool canReply = canVote && root?.id != null;

    // We don't want the slidable to update while being slided, so we delay any
    // upvote state until after the call has actually finished.
    final StateController<bool> delayedUpvotedController =
        useProvider(delayedUpvoteStateProvider(item.id));

    Future<void> updateDelayedUpvoted() async {
      final bool upvoted = await context.read(upvotedProvider(item.id).future);

      if (delayedUpvotedController.mounted) {
        delayedUpvotedController.state = upvoted;
      }
    }

    Future<void> vote({@required bool up}) async {
      await _vote(context, up: up);
      unawaited(updateDelayedUpvoted());
    }

    useMemoized(updateDelayedUpvoted);

    return Slidable(
      key: ValueKey<int>(item.id),
      startToEndAction: canVote && delayedUpvotedController.state != null
          ? !delayedUpvotedController.state
              ? SlidableAction(
                  action: () => vote(up: true),
                  icon: FluentIcons.arrow_up_24_filled,
                  color: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.onPrimary,
                )
              : SlidableAction(
                  action: () => vote(up: false),
                  icon: FluentIcons.arrow_undo_24_filled,
                )
          : null,
      endToStartAction: dense
          ? item.url != null
              ? SlidableAction(
                  action: () => UrlUtil.tryLaunch(item.url),
                  icon: FluentIcons.window_arrow_up_24_regular,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null
          : canReply
              ? SlidableAction(
                  action: () => _reply(context),
                  icon: FluentIcons.arrow_reply_24_filled,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null,
      child: _buildTappable(context, active: active),
    );
  }

  Widget _buildTappable(BuildContext context, {@required bool active}) {
    return InkWell(
      onTap: active && onTap != null
          ? item.type == ItemType.pollopt && interactive
              ? () => _vote(
                    context,
                    up: !context.read(upvotedProvider(item.id)).maybeWhen(
                          data: (bool upvoted) => upvoted,
                          orElse: () => false,
                        ),
                  )
              : onTap
          : null,
      onLongPress: active ? () => _buildModalBottomSheet(context) : null,
      child: fadeable ? _buildFadeable(context) : _buildContent(context),
    );
  }

  Widget _buildFadeable(BuildContext context) {
    final bool visibility = useProvider(visitedProvider(item.id)).maybeWhen(
      data: (bool value) => value,
      orElse: () => false,
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: visibility ? 2 / 3 : 1,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: item.type == ItemType.pollopt
          ? ItemTileContentPollOption(
              item,
              root: root,
              interactive: interactive,
              vote: _vote,
            )
          : ItemTileContent(
              item,
              root: root,
              dense: dense,
              interactive: interactive,
            ),
    );
  }

  Future<void> _buildModalBottomSheet(BuildContext context) async {
    final AsyncValue<bool> favorited = context.read(favoritedProvider(item.id));

    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => Wrap(
        children: <Widget>[
          if (favorited.data != null)
            if (favorited.data.value)
              ListTile(
                title: const Text('Unfavorite'),
                onTap: () {
                  _favorite(context, favorite: false);
                  Navigator.of(context).pop();
                },
              )
            else
              ListTile(
                title: const Text('Favorite'),
                onTap: () {
                  _favorite(context, favorite: true);
                  Navigator.of(context).pop();
                },
              ),
          if (item.text != null)
            ListTile(
              title: const Text('Copy text'),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: item.text));
                ScaffoldMessenger.of(context).showSnackBarQuickly(
                  const SnackBar(content: Text('Text has been copied')),
                );
                Navigator.of(context).pop();
              },
            ),
          if (item.url != null)
            ListTile(
              title: const Text('Share link'),
              onTap: () async {
                await Share.share(item.url);
                Navigator.of(context).pop();
              },
            ),
          ListTile(
            title: const Text('Share item link'),
            onTap: () async {
              await Share.share(
                  '${WebsiteRepository.baseUrl}/item?id=${item.id}');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _favorite(BuildContext context, {@required bool favorite}) {
    context.read(authRepositoryProvider).favorite(
          id: item.id,
          favorite: favorite,
          onUpdate: () => context
            ..refresh(favoritedProvider(item.id))
            ..refresh(favoriteIdsProvider),
        );
  }

  Future<void> _vote(BuildContext context, {@required bool up}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await authRepository.vote(
        id: item.id,
        up: up,
        onUpdate: () => context.refresh(upvotedProvider(item.id)),
      );

      if (success) {
        if (item.score != null) {
          context.read(itemCacheStateProvider(item.id)).state =
              item.copyWith(score: item.score + (up ? 1 : -1));
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
      );

      if (success == true && root?.id != null) {
        context.refresh(itemTreeStreamProvider(root.id));
        ScaffoldMessenger.of(context).showSnackBarQuickly(
          SnackBar(
            content: const Text(
              'Processing may take a moment, '
              'consider refreshing for an updated view',
            ),
            action: SnackBarAction(
              label: 'Refresh',
              onPressed: () async {
                await reloadItemTree(context.refresh, id: root.id);
                return context.refresh(itemTreeStreamProvider(root.id));
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
