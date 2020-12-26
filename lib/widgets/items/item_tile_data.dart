import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/models/slidable_action.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/reply_page.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:glider/widgets/common/tile_loading.dart';
import 'package:glider/widgets/common/tile_loading_block.dart';
import 'package:glider/widgets/common/slidable.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/common/metadata_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';

class ItemTileData extends HookWidget {
  const ItemTileData(
    this.item, {
    Key key,
    this.root,
    this.onTap,
    this.dense = false,
    this.fadeable = false,
  }) : super(key: key);

  final Item item;
  final Item root;
  final void Function() onTap;
  final bool dense;
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
    final bool active = item.id != null && item.deleted != true;
    final bool canVote = active && item.type != ItemType.job;
    final bool canReply =
        active && item.type != ItemType.job && item.type != ItemType.pollopt;

    return Slidable(
      key: ValueKey<int>(item.id),
      startToEndAction: canVote
          ? useProvider(upvotedProvider(item.id)).maybeWhen(
              data: (bool upvoted) => !upvoted
                  ? SlidableAction(
                      action: () => _handleVote(context, up: true),
                      icon: FluentIcons.arrow_up_24_filled,
                      color: Theme.of(context).colorScheme.primary,
                      iconColor: Theme.of(context).colorScheme.onPrimary,
                    )
                  : SlidableAction(
                      action: () => _handleVote(context, up: false),
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
                  action: () => _handleReply(context),
                  icon: FluentIcons.arrow_reply_24_filled,
                  color: Theme.of(context).colorScheme.surface,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                )
              : null,
      child: _buildTappable(context, active),
    );
  }

  Widget _buildTappable(BuildContext context, bool active) {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
              if (active && item.title != null) ...<Widget>[
                _buildStorySection(textTheme),
                const SizedBox(height: 12),
              ],
              _buildMetadataSection(context, textTheme),
              SmoothAnimatedSwitcher(
                condition: dense,
                falseChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (item.text != null) ...<Widget>[
                      const SizedBox(height: 12),
                      _buildTextSection(),
                    ],
                    if (item.url != null) ...<Widget>[
                      const SizedBox(height: 12),
                      _buildUrlSection(textTheme),
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

  Widget _buildStorySection(TextTheme textTheme) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: ItemTile.thumbnailSize),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: 'item_title_${item.id}',
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: item.title,
                      style: textTheme.subtitle1,
                    ),
                    if (item.url != null) ...<InlineSpan>[
                      TextSpan(text: ' ', style: textTheme.subtitle1),
                      TextSpan(
                        text: '(${item.urlHost})',
                        style: textTheme.caption.copyWith(height: 1.6),
                      ),
                    ]
                  ],
                ),
                maxLines: dense ? 2 : null,
                overflow: dense ? TextOverflow.ellipsis : null,
              ),
            ),
          ),
          if (item.url != null) ...<Widget>[
            const SizedBox(width: 12),
            Hero(
              tag: 'item_thumbnail_${item.id}',
              child: CachedNetworkImage(
                imageUrl: item.thumbnailUrl,
                imageBuilder: (_, ImageProvider<dynamic> imageProvider) =>
                    Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                placeholder: (_, __) => const TileLoading(
                  animate: false,
                  child: TileLoadingBlock(),
                ),
                width: ItemTile.thumbnailSize,
                height: ItemTile.thumbnailSize,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context, TextTheme textTheme) {
    Widget upvotedMetadata({bool upvoted = false}) => MetadataItem(
          key: ValueKey<bool>(upvoted),
          icon: FluentIcons.arrow_up_24_regular,
          text: item.score?.toString(),
          highlight: upvoted,
        );
    final Widget upvotedMetadataTrue = upvotedMetadata(upvoted: true);
    final Widget upvotedMetadataFalse =
        item.score != null ? upvotedMetadata() : const SizedBox.shrink();

    return Hero(
      tag: 'item_metadata_${item.id}',
      child: Row(
        children: <Widget>[
          useProvider(favoritedProvider(item.id)).maybeWhen(
            data: (bool favorited) => SmoothAnimatedSwitcher(
              condition: favorited,
              trueChild: const MetadataItem(
                icon: FluentIcons.star_24_regular,
                highlight: true,
              ),
              axis: Axis.horizontal,
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          useProvider(upvotedProvider(item.id)).maybeWhen(
            data: (bool upvoted) => SmoothAnimatedSwitcher(
              transitionBuilder: item.score != null
                  ? SmoothAnimatedSwitcher.fadeTransitionBuilder
                  : null,
              condition: upvoted,
              trueChild: upvotedMetadataTrue,
              falseChild: upvotedMetadataFalse,
              axis: Axis.horizontal,
            ),
            orElse: () => upvotedMetadataFalse,
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
          if (item.deleted == true)
            const MetadataItem(
              icon: FluentIcons.comment_delete_24_regular,
              text: '[deleted]',
            )
          else if (item.by != null && item.type != ItemType.pollopt)
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UserPage(id: item.by),
                ),
              ),
              child: Row(children: <Widget>[
                if (item.by == root?.by)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.by,
                      style: textTheme.caption.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      item.by,
                      style: textTheme.caption.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                const SizedBox(width: 8),
              ]),
            ),
          if (item.type == ItemType.comment)
            SmoothAnimatedSwitcher(
              transitionBuilder: SmoothAnimatedSwitcher.fadeTransitionBuilder,
              condition: dense,
              trueChild: MetadataItem(
                icon: FluentIcons.add_circle_24_regular,
                text: item.kids?.length?.toString(),
              ),
            ),
          const Spacer(),
          if (item.type != ItemType.pollopt)
            Text(
              item.timeAgo,
              style: textTheme.caption,
            ),
        ],
      ),
    );
  }

  Widget _buildTextSection() {
    return Hero(
      tag: 'item_text_${item.id}',
      child: DecoratedHtml(item.text),
    );
  }

  Widget _buildUrlSection(TextTheme textTheme) {
    return Hero(
      tag: 'item_url_${item.id}',
      child: GestureDetector(
        onTap: () => UrlUtil.tryLaunch(item.url),
        child: Block(
          child: Row(
            children: <Widget>[
              Icon(
                FluentIcons.open_in_browser_24_regular,
                size: textTheme.bodyText2.fontSize,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.url,
                  style: textTheme.bodyText2
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleFavorite(BuildContext context,
      {@required bool favorite}) async {
    await context
        .read(authRepositoryProvider)
        .favorite(id: item.id, favorite: favorite);
    await context.refresh(favoritedProvider(item.id));
    await context.refresh(favoriteIdsProvider);
  }

  Future<void> _handleVote(BuildContext context, {@required bool up}) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await authRepository.vote(id: item.id, up: up);

      if (success) {
        await context.refresh(upvotedProvider(item.id));

        if (item.score != null) {
          context.read(itemOverrideProvider(item.id)).state =
              item.copyWith(score: item.score + (up ? 1 : -1));
          await context.refresh(itemProvider(item.id));
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

  Future<void> _handleReply(BuildContext context) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => ReplyPage(replyToItem: item),
          fullscreenDialog: true,
        ),
      );

      if (success != null && success && root?.id != null) {
        ScaffoldMessenger.of(context).showSnackBarQuickly(
          SnackBar(
            content: const Text(
              'Reply has been submitted, '
              'but it may not show up immediately',
            ),
            action: SnackBarAction(
              label: 'Refresh',
              onPressed: () => context.refresh(itemTreeStreamProvider(root.id)),
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
                          await _handleFavorite(context, favorite: true);
                          Navigator.of(context).pop();
                        },
                      )
                    : ListTile(
                        title: const Text('Unfavorite'),
                        onTap: () async {
                          await _handleFavorite(context, favorite: false);
                          Navigator.of(context).pop();
                        },
                      ),
                orElse: () => null,
              ),
          if (item.url != null) ...<Widget>[
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
