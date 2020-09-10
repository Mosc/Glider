import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/utils/url_util.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/decorated_html.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:glider/widgets/common/loading_block.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/common/tile_meta_data_item.dart';

class ItemTileData extends HookWidget {
  const ItemTileData(
    this.item, {
    Key key,
    this.rootBy,
    this.onTap,
    this.dense = false,
    this.separator,
  }) : super(key: key);

  final Item item;
  final String rootBy;
  final void Function() onTap;
  final bool dense;
  final Widget separator;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool indented = item.ancestors != null && item.ancestors.isNotEmpty;

    return Container(
      margin: indented
          ? EdgeInsets.only(left: (8 * item.ancestors.length - 2).toDouble())
          : EdgeInsets.zero,
      decoration: indented
          ? BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
            )
          : null,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: item.deleted != true && onTap != null ? onTap : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (item.parent == null) ...<Widget>[
                    _buildStorySection(textTheme),
                    const SizedBox(height: 12),
                  ],
                  _buildMetaDataSection(context, textTheme),
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
          if (separator != null) separator,
        ],
      ),
    );
  }

  Widget _buildStorySection(TextTheme textTheme) {
    return Row(
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
            placeholder: (_, __) => const Loading(child: LoadingBlock()),
            width: ItemTile.thumbnailSize,
            height: ItemTile.thumbnailSize,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaDataSection(BuildContext context, TextTheme textTheme) {
    return Hero(
      tag: 'item_meta_data_${item.id}',
      child: Row(
        children: <Widget>[
          if (item.deleted == true)
            const TileMetaDataItem(
              icon: Icons.close,
              text: '[deleted]',
            )
          else
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UserPage(id: item.by),
                ),
              ),
              child: Row(children: <Widget>[
                if (item.by == rootBy)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.by,
                      style: textTheme.caption
                          .copyWith(color: textTheme.bodyText2.color),
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
          if (item.score != null)
            TileMetaDataItem(
              icon: Icons.favorite_outline,
              text: item.score.toString(),
            ),
          if (item.descendants != null)
            TileMetaDataItem(
              icon: Icons.chat_bubble_outline,
              text: item.descendants.toString(),
            ),
          if (item.type == ItemType.job)
            const TileMetaDataItem(icon: Icons.work_outline)
          else if (item.type == ItemType.poll)
            const TileMetaDataItem(icon: Icons.poll),
          if (item.type == ItemType.comment)
            SmoothAnimatedSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  FadeTransition(opacity: animation, child: child),
              condition: dense,
              trueChild: TileMetaDataItem(
                icon: Icons.add_circle_outline,
                text: item.kids?.length?.toString(),
              ),
            ),
          const Spacer(),
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
                Icons.open_in_browser,
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
}
