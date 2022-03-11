import 'package:flutter/material.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/utils/async_notifier.dart';
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
    final AutoDisposeStateNotifierProvider<AsyncNotifier<Iterable<int>>,
        AsyncValue<Iterable<int>>> provider = favoriteIdsNotifierProvider;

    return RefreshableBody<Iterable<int>>(
      provider: provider,
      onRefresh: () => ref.read(provider.notifier).forceLoad(),
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
          builder: (_, int id, int index) => ItemTile(
            id: id,
            onTap: (BuildContext context) => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
            ),
            loading: ({int? indentation}) => _buildItemLoading(index),
            refreshProvider: provider,
          ),
        ),
      ],
    );
  }

  Widget _buildItemLoading(int index) {
    return index.isEven ? const StoryTileLoading() : const CommentTileLoading();
  }
}
