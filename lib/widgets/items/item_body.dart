import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemBody extends HookWidget {
  const ItemBody({Key key, @required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    useMemoized(() => _refresh(context));

    final ValueNotifier<Set<int>> collapsedNotifier = useState(<int>{});

    return RefreshableBody<ItemTree>(
      provider: itemTreeStreamProvider(id),
      onRefresh: () => _refresh(context),
      loadingBuilder: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, int index) => _buildItemLoading(index),
        ),
      ),
      dataBuilder: (ItemTree itemTree) {
        final Item firstItem = itemTree.items.first;
        final int parent = firstItem?.parent ?? firstItem?.poll;
        return <Widget>[
          if (parent != null)
            SliverToBoxAdapter(child: _buildOpenParent(context, parent)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) => _loaded(itemTree, index)
                  ? _buildItem(itemTree, index, collapsedNotifier)
                  : _buildItemLoading(index),
              childCount: itemTree.hasMore ? null : itemTree.items.length,
            ),
          ),
        ];
      },
    );
  }

  Future<void> _refresh(BuildContext context) async {
    await reloadItemTree(context.refresh, id: id);
    return context.refresh(itemTreeStreamProvider(id));
  }

  bool _loaded(ItemTree itemTree, int index) => index < itemTree.items.length;

  Widget _buildItemLoading(int index) {
    return index == 0 ? const StoryTileLoading() : const CommentTileLoading();
  }

  Widget _buildItem(
      ItemTree itemTree, int index, ValueNotifier<Set<int>> collapsedNotifier) {
    final Item item = itemTree.items.elementAt(index);
    final bool collapsed = _collapsed(collapsedNotifier, item.id);

    return SmoothAnimatedSwitcher(
      condition: _collapsedAncestors(collapsedNotifier, item.ancestors),
      falseChild: ItemTile(
        id: item.id,
        ancestors: item.ancestors,
        root: itemTree.items.first,
        onTap: item.type == ItemType.comment
            ? () => _collapse(collapsedNotifier, item.id)
            : null,
        dense: collapsed,
        loading: () => _buildItemLoading(index),
      ),
    );
  }

  Widget _buildOpenParent(BuildContext context, int parentId) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Hero(
        tag: 'open_parent',
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => ItemPage(id: parentId)),
          ),
          child: Block(
            child: Row(
              children: <Widget>[
                Icon(
                  FluentIcons.arrow_up_circle_24_regular,
                  size: Theme.of(context).textTheme.bodyText2.fontSize,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Open the parent of this single thread',
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

  void _collapse(ValueNotifier<Set<int>> collapsedNotifier, int id) {
    if (collapsedNotifier.value.contains(id)) {
      collapsedNotifier.value.remove(id);
    } else {
      collapsedNotifier.value.add(id);
    }

    collapsedNotifier.value = <int>{...collapsedNotifier.value};
  }

  bool _collapsed(ValueNotifier<Set<int>> collapsedNotifier, int id) =>
      collapsedNotifier.value.contains(id);

  bool _collapsedAncestors(
          ValueNotifier<Set<int>> collapsedNotifier, Iterable<int> ids) =>
      ids.any((int ancestor) => _collapsed(collapsedNotifier, ancestor));
}
