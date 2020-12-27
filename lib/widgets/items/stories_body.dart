import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/items/story_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoriesBody extends HookWidget {
  const StoriesBody({Key key}) : super(key: key);

  static const double _storyExtent = 90;

  @override
  Widget build(BuildContext context) {
    final StateController<StoryType> storyTypeStateController =
        useProvider(navigationItemStateProvider);

    return RefreshableBody<Iterable<int>>(
      provider: storyIdsProvider(storyTypeStateController.state),
      loadingBuilder: () => SliverFixedExtentList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const StoryTileLoading(),
        ),
        itemExtent: _storyExtent,
      ),
      dataBuilder: (Iterable<int> ids) => <Widget>[
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) {
              final int id = ids.elementAt(index);
              context.refresh(itemProvider(id));
              return StoryTile(id: id);
            },
            childCount: ids.length,
          ),
          itemExtent: _storyExtent,
        ),
      ],
    );
  }
}
