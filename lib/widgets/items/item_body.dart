import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/items/collapsible_item_tile.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemBody extends HookConsumerWidget {
  const ItemBody({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useMemoized(() => _refresh(ref));

    return RefreshableBody<ItemTree>(
      provider: itemTreeStreamProvider(id),
      onRefresh: () => _refresh(ref),
      loadingBuilder: () => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildItemLoading(index),
          ),
        ),
      ],
      dataBuilder: (ItemTree itemTree) {
        final Iterable<Item> items = itemTree.items;
        final Item? firstItem = items.isNotEmpty ? items.first : null;
        final int? parent = firstItem?.parent ?? firstItem?.poll;
        return <Widget>[
          if (parent != null)
            SliverToBoxAdapter(child: _buildOpenParent(context, parent)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                if (_loaded(items, index)) {
                  final Item item = items.elementAt(index);
                  return CollapsibleItemTile(
                    id: item.id,
                    ancestors: item.ancestors,
                    root: items.first,
                    loading: () => _buildItemLoading(index),
                  );
                } else {
                  return _buildItemLoading(index);
                }
              },
              childCount: itemTree.done ? items.length : null,
            ),
          ),
        ];
      },
    );
  }

  Future<void> _refresh(WidgetRef ref) async {
    await reloadItemTree(ref.read, id: id);
    ref.refresh(itemTreeStreamProvider(id));
  }

  bool _loaded(Iterable<Item> items, int index) => index < items.length;

  Widget _buildItemLoading(int index) {
    return index == 0 ? const StoryTileLoading() : const CommentTileLoading();
  }

  Widget _buildOpenParent(BuildContext context, int parentId) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => ItemPage(id: parentId)),
        ),
        child: Hero(
          tag: 'open_parent',
          child: Block(
            child: Row(
              children: <Widget>[
                Icon(
                  FluentIcons.arrow_circle_up_24_regular,
                  size: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.scaledFontSize(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    appLocalizations.openParent,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
