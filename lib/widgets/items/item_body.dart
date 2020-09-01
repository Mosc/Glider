import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_family.dart';
import 'package:glider/models/item_type.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/separated_sliver_list.dart';
import 'package:glider/widgets/common/separator.dart';
import 'package:glider/widgets/items/item_tile_data.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemBody extends HookWidget {
  const ItemBody({Key key, @required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    // This non-stream version retrieves an item's kids concurrently, possibly
    // out of order, and returns them all at once. Its results are thefore not
    // used, but the caching it causes is useful for the stream provider.
    useProvider(itemFamilyProvider(id));
    final ValueNotifier<Set<int>> collapsedNotifier = useState(<int>{});

    return RefreshIndicator(
      onRefresh: () {
        context.read(repositoryProvider).clearItemCache();
        context.refresh(itemFamilyStreamProvider(id));
        return context.refresh(itemFamilyProvider(id));
      },
      child: CustomScrollView(
        slivers: <Widget>[
          useProvider(itemFamilyStreamProvider(id)).when(
            loading: () => SliverList(
              delegate: SeparatedSliverChildBuilderDelegate(
                itemBuilder: (_, int index) => index == 0
                    ? const StoryTileLoading()
                    : const CommentTileLoading(),
                separatorBuilder: (_, __) => const Separator(),
              ),
            ),
            error: (Object error, StackTrace stackTrace) =>
                const SliverFillRemaining(child: Error()),
            data: (ItemFamily itemFamily) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index < itemFamily.items.length) {
                    final Item item = itemFamily.items[index];
                    return Column(
                      children: <Widget>[
                        if (index == 0 && item.parent != null) ...<Widget>[
                          _buildOpenParent(context, item),
                          const Separator(),
                        ],
                        SmoothAnimatedSwitcher(
                          condition: _hasCollapsedAncestors(
                              collapsedNotifier, item.ancestors),
                          falseChild: ItemTileData(
                            item,
                            rootBy: itemFamily.items.first.by,
                            onTap: item.type == ItemType.comment
                                ? () =>
                                    _toggleCollapsed(collapsedNotifier, item.id)
                                : null,
                            dense: _isCollapsed(collapsedNotifier, item.id),
                            separator: const Separator(),
                          ),
                        ),
                      ],
                    );
                  } else if (itemFamily.hasMore) {
                    return const CommentTileLoading();
                  } else {
                    return const End();
                  }
                },
                childCount:
                    itemFamily.hasMore ? null : itemFamily.items.length + 1,
              ),
            ),
          ),
        ],
      ),
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
                  Icons.arrow_circle_up,
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

  void _toggleCollapsed(ValueNotifier<Set<int>> collapsedNotifier, int id) {
    if (collapsedNotifier.value.contains(id)) {
      collapsedNotifier.value.remove(id);
    } else {
      collapsedNotifier.value.add(id);
    }

    collapsedNotifier.value = <int>{...collapsedNotifier.value};
  }

  bool _isCollapsed(ValueNotifier<Set<int>> collapsedNotifier, int id) =>
      collapsedNotifier.value.contains(id);

  bool _hasCollapsedAncestors(
          ValueNotifier<Set<int>> collapsedNotifier, List<int> ids) =>
      ids.any((int ancestor) => _isCollapsed(collapsedNotifier, ancestor));
}
