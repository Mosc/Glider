import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/pages/stories_search_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoriesSearchBody extends HookWidget {
  const StoriesSearchBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshableBody<Iterable<int>>(
      provider: storyIdsSearchProvider(
        SearchParameters(
          query: useProvider(storySearchQueryStateProvider).state,
          searchRange: useProvider(storySearchRangeStateProvider).state,
          storyType: useProvider(storySearchTypeStateProvider).state,
        ),
      ),
      loadingBuilder: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, __) => const StoryTileLoading(),
        ),
      ),
      dataBuilder: (Iterable<int> ids) => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) {
              final int id = ids.elementAt(index);
              return ItemTile(
                id: id,
                onTap: (_) => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
                ),
                dense: true,
                fadeable: true,
                loading: () => const StoryTileLoading(),
              );
            },
            childCount: ids.length,
          ),
        ),
      ],
    );
  }
}
