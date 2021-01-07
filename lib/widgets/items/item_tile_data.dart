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
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile_header.dart';
import 'package:glider/widgets/items/item_tile_metadata.dart';
import 'package:glider/widgets/items/item_tile_preview.dart';
import 'package:glider/widgets/items/item_tile_text.dart';
import 'package:glider/widgets/items/item_tile_url.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';

class ItemTileData extends HookWidget {
  const ItemTileData(
    this.item, {
    Key key,
    this.root,
    this.onTap,
    this.dense = false,
    this.collapsible = false,
    this.fadeable = false,
  }) : super(key: key);

  final Item item;
  final Item root;
  final void Function() onTap;
  final bool dense;
  final bool collapsible;
  final bool fadeable;

  @override
  Widget build(BuildContext context) {
    final bool indented = item.ancestors != null && item.ancestors.isNotEmpty;

    return Stack(
      children: <Widget>[
        if (indented && item.ancestors != null)
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
    final bool canVote = active && item.type != ItemType.job;
    final bool canReply = active &&
        item.type != ItemType.job &&
        item.type != ItemType.pollopt &&
        root?.id != null;

    return Slidable(
      key: ValueKey<int>(item.id),
      startToEndAction: canVote
          ? useProvider(upvotedProvider(item.id)).maybeWhen(
              data: (bool upvoted) => !upvoted
                  ? SlidableAction(
                      action: () => _vote(context, up: true),
                      icon: FluentIcons.arrow_up_24_filled,
                      color: Theme.of(context).colorScheme.primary,
                      iconColor: Theme.of(context).colorScheme.onPrimary,
                    )
                  : SlidableAction(
                      action: () => _vote(context, up: false),
                      icon: FluentIcons.arrow_undo_24_filled,
                    ),
              orElse: () => null,
            )
          : null,
      endToStartAction: dense
          ? item.url != null
              ? SlidableAction(
                  action: () => UrlUtil.tryLaunch(item.url),
                  icon: FluentIcons.open_in_browser_24_filled,
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
    final bool visited = fadeable &&
        useProvider(visitedProvider(item.id)).maybeWhen(
          data: (bool value) => value,
          orElse: () => false,
        );

    return InkWell(
      onTap: active && onTap != null ? onTap : null,
      onLongPress: active ? () => _buildModalBottomSheet(context) : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: visited ? 2 / 3 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (item.localOnly) ...<Widget>[
                const ItemTilePreview(),
                const SizedBox(height: 12),
              ],
              if (item.title != null) ...<Widget>[
                ItemTileHeader(item, dense: dense),
                const SizedBox(height: 12),
              ],
              ItemTileMetadata(
                item,
                root: root,
                dense: dense,
                collapsible: collapsible,
              ),
              SmoothAnimatedSwitcher(
                condition: !dense,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (item.text != null) ...<Widget>[
                      const SizedBox(height: 12),
                      ItemTileText(item),
                    ],
                    if (item.url != null) ...<Widget>[
                      const SizedBox(height: 12),
                      ItemTileUrl(item),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _favorite(BuildContext context,
      {@required bool favorite}) async {
    await context
        .read(authRepositoryProvider)
        .favorite(id: item.id, favorite: favorite);
    await context.refresh(favoritedProvider(item.id));
    await context.refresh(favoriteIdsProvider);
  }

  Future<void> _vote(BuildContext context, {@required bool up}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await authRepository.vote(id: item.id, up: up);

      if (success) {
        await context.refresh(upvotedProvider(item.id));

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

  Future<void> _buildModalBottomSheet(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => Wrap(
        children: <Widget>[
          context.read(favoritedProvider(item.id)).maybeWhen(
                data: (bool favorited) => !favorited
                    ? ListTile(
                        title: const Text('Favorite'),
                        onTap: () async {
                          await _favorite(context, favorite: true);
                          Navigator.of(context).pop();
                        },
                      )
                    : ListTile(
                        title: const Text('Unfavorite'),
                        onTap: () async {
                          await _favorite(context, favorite: false);
                          Navigator.of(context).pop();
                        },
                      ),
                orElse: () => const SizedBox.shrink(),
              ),
          if (item.url != null) ...<Widget>[
            if (!dense)
              ListTile(
                title: const Text('Open link'),
                onTap: () async {
                  await UrlUtil.tryLaunch(item.url);
                  Navigator.of(context).pop();
                },
              ),
            ListTile(
              title: const Text('Share link'),
              onTap: () async {
                await Share.share(item.url);
                Navigator.of(context).pop();
              },
            ),
          ],
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
}
