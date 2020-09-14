import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/separated_sliver_child_builder_delegate.dart';
import 'package:glider/widgets/common/separator.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoriesBody extends HookWidget {
  const StoriesBody({Key key, this.scrollController}) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final StateController<NavigationItem> navigationItemStateController =
        useProvider(navigationItemStateProvider);

    return RefreshIndicator(
      onRefresh: () {
        return context
            .refresh(storyIdsProvider(navigationItemStateController.state));
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          useProvider(storyIdsProvider(navigationItemStateController.state))
              .when(
            loading: () => SliverList(
              delegate: SeparatedSliverChildBuilderDelegate(
                itemBuilder: (_, __) => const StoryTileLoading(),
                separatorBuilder: (_, __) => const Separator(),
              ),
            ),
            error: (_, __) => const SliverFillRemaining(child: Error()),
            data: (Iterable<int> ids) => SliverList(
              delegate: SeparatedSliverChildBuilderDelegate(
                itemBuilder: (_, int index) {
                  if (index < ids.length) {
                    final int id = ids.elementAt(index);
                    return ItemTile(
                      id: ids.elementAt(index),
                      dense: true,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => ItemPage(id: id)),
                      ),
                      loading: () => const StoryTileLoading(),
                    );
                  } else {
                    return const End();
                  }
                },
                separatorBuilder: (_, __) => const Separator(),
                childCount: ids.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
