import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:glider/utils/text_style_extension.dart';
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

    final ValueNotifier<Set<int>> collapsedState = useState(<int>{});

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
        final Iterable<Item> items = itemTree.items;
        return <Widget>[
          if (parent != null)
            SliverToBoxAdapter(child: _buildOpenParent(context, parent)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) => _loaded(items, index)
                  ? _buildItem(items, index, collapsedState)
                  : _buildItemLoading(index),
              childCount: itemTree.done ? items.length : null,
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

  bool _loaded(Iterable<Item> items, int index) => index < items.length;

  Widget _buildItemLoading(int index) {
    return index == 0 ? const StoryTileLoading() : const CommentTileLoading();
  }

  Widget _buildItem(
      Iterable<Item> items, int index, ValueNotifier<Set<int>> collapsedState) {
    final Item item = items.elementAt(index);

    return SmoothAnimatedSwitcher.vertical(
      condition: !_collapsedAncestors(collapsedState, item.ancestors),
      child: ItemTile(
        id: item.id,
        ancestors: item.ancestors,
        root: items.first.parent != null ? null : items.first,
        onTap: (BuildContext context) {
          final ScrollableState scrollableState = Scrollable.of(context);
          scrollableState.position.ensureVisible(
            context.findRenderObject(),
            duration: AnimationUtil.defaultDuration,
            curve: Curves.easeInOut,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
          );
          _collapse(collapsedState, item.id);
        },
        dense: _collapsed(collapsedState, item.id),
        interactive: true,
        loading: () => _buildItemLoading(index),
      ),
    );
  }

  Widget _buildOpenParent(BuildContext context, int parentId) {
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
                      .scaledFontSize(context),
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

  void _collapse(ValueNotifier<Set<int>> collapsedState, int id) {
    if (collapsedState.value.contains(id)) {
      collapsedState.value.remove(id);
    } else {
      collapsedState.value.add(id);
    }

    collapsedState.value = <int>{...collapsedState.value};
  }

  bool _collapsed(ValueNotifier<Set<int>> collapsedState, int id) =>
      collapsedState.value.contains(id);

  bool _collapsedAncestors(
          ValueNotifier<Set<int>> collapsedState, Iterable<int> ids) =>
      collapsedState.value.isNotEmpty &&
      ids.any((int ancestor) =>
          id != ancestor && _collapsed(collapsedState, ancestor));
}
