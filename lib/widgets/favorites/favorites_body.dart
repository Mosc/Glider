import 'package:flutter/material.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/common/sliver_smooth_animated_list.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesBody extends HookConsumerWidget {
  const FavoritesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshableBody<Iterable<int>>(
      provider: favoriteIdsNotifierProvider,
      loadingBuilder: () => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildItemLoading(index),
          ),
        ),
      ],
      dataBuilder: (Iterable<int> ids) => <Widget>[
        SliverSmoothAnimatedList<int>(
          items: ids,
          builder: (_, int id, int index) {
            return ItemTile(
              id: id,
              onTap: (_) => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
              ),
              loading: () => _buildItemLoading(index),
            );
          },
        ),
      ],
    );
  }

  Widget _buildItemLoading(int index) {
    return index.isEven ? const StoryTileLoading() : const CommentTileLoading();
  }
}
