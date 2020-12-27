import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';

class FavoritesBody extends HookWidget {
  const FavoritesBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshableBody<Iterable<int>>(
      provider: favoriteIdsProvider,
      loadingBuilder: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, int index) => _buildItemLoading(index),
        ),
      ),
      dataBuilder: (Iterable<int> ids) => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) {
              final int id = ids.elementAt(index);
              return ItemTile(
                id: id,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
                ),
                loading: () => _buildItemLoading(index),
              );
            },
            childCount: ids.length,
          ),
        ),
      ],
    );
  }

  Widget _buildItemLoading(int index) {
    return index.isEven ? const StoryTileLoading() : const CommentTileLoading();
  }
}
