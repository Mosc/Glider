import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_tree.dart';
import 'package:glider/models/item_tree_parameter.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/separated_sliver_child_builder_delegate.dart';
import 'package:glider/widgets/common/separator.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemBody extends HookWidget {
  const ItemBody({Key key, @required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Set<int>> collapsedNotifier = useState(<int>{});

    return RefreshIndicator(
      onRefresh: () => context.refresh(itemProvider(id)),
      child: CustomScrollView(
        slivers: <Widget>[
          useProvider(itemTreeStreamProvider(ItemTreeParameter(id: id))).when(
            loading: () => SliverList(
              delegate: SeparatedSliverChildBuilderDelegate(
                itemBuilder: (_, int index) => index == 0
                    ? const StoryTileLoading()
                    : const CommentTileLoading(),
                separatorBuilder: (_, __) => const Separator(),
              ),
            ),
            error: (_, __) => const SliverFillRemaining(child: Error()),
            data: (ItemTree itemTree) => SliverList(
              // We're not using a SeparatedSliverChildBuilderDelegate here
              // because we want the separator to be indented based on the item
              // depth. This means letting ItemTileData render its own separator
              // instead.
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index < itemTree.items.length) {
                    return _buildItem(
                        context, itemTree, index, collapsedNotifier);
                  } else if (itemTree.hasMore) {
                    return const CommentTileLoading();
                  } else {
                    return const End();
                  }
                },
                childCount: itemTree.hasMore ? null : itemTree.items.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, ItemTree itemTree, int index,
      ValueNotifier<Set<int>> collapsedNotifier) {
    final Item item = itemTree.items.elementAt(index);
    final bool collapsed = _collapsed(collapsedNotifier, item.id);

    // Indent the separator if the item has children and these are visible
    // because the item is not collapsed.
    final bool indentSeparator =
        item.kids != null && item.kids.isNotEmpty && !collapsed;

    return Column(
      children: <Widget>[
        if (index == 0 && item.parent != null) ...<Widget>[
          _buildOpenParent(context, item),
          const Separator(),
        ],
        SmoothAnimatedSwitcher(
          condition: _collapsedAncestors(collapsedNotifier, item.ancestors),
          falseChild: ItemTileData(
            item,
            root: itemTree.items.first,
            onTap: item.type == ItemType.comment
                ? () => _collapse(collapsedNotifier, item.id)
                : null,
            dense: collapsed,
            separator: indentSeparator
                ? const Separator()
                : const Separator(startIndent: 0),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenParent(BuildContext context, Item item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Hero(
        tag: 'open_parent',
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => ItemPage(id: item.parent)),
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
                    'Open the parent of this single comment thread',
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
