import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/items/story_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoriesBody extends HookWidget {
  const StoriesBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StateController<NavigationItem> navigationItemStateController =
        useProvider(navigationItemStateProvider);

    return RefreshIndicator(
      onRefresh: () => context
          .refresh(storyIdsProvider(navigationItemStateController.state)),
      child: CustomScrollView(
        slivers: <Widget>[
          useProvider(storyIdsProvider(navigationItemStateController.state))
              .when(
            loading: () => SliverPrototypeExtentList(
              delegate: SliverChildBuilderDelegate(
                (_, __) => const StoryTileLoading(),
              ),
              prototypeItem: const StoryTileLoading(),
            ),
            error: (_, __) => const SliverFillRemaining(child: Error()),
            data: (Iterable<int> ids) => SliverPrototypeExtentList(
              delegate: SliverChildBuilderDelegate(
                (_, int index) {
                  if (index < ids.length) {
                    final int id = ids.elementAt(index);
                    context.refresh(itemProvider(id));
                    return StoryTile(id: id);
                  } else {
                    return const End();
                  }
                },
                childCount: ids.length + 1,
              ),
              prototypeItem: const StoryTileLoading(),
            ),
          ),
        ],
      ),
    );
  }
}
