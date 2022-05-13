import 'package:flutter/material.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/utils/async_notifier.dart';
import 'package:glider/utils/pagination_mixin.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<int> favoritesPaginationStateProvider =
    StateProvider.autoDispose<int>(
  (AutoDisposeStateProviderRef<int> ref) => PaginationMixin.initialPage,
);

class FavoritesBody extends HookConsumerWidget with PaginationMixin {
  const FavoritesBody({super.key});

  @override
  AutoDisposeStateProvider<int> get paginationStateProvider =>
      favoritesPaginationStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoDisposeStateNotifierProvider<AsyncNotifier<Iterable<int>>,
        AsyncValue<Iterable<int>>> provider = favoriteIdsNotifierProvider;

    return RefreshableBody<Iterable<int>>(
      provider: provider,
      onRefresh: () async {
        resetPagination(ref);
        await ref.read(provider.notifier).forceLoad();
      },
      loadingBuilder: () => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildItemLoading(index),
          ),
        ),
      ],
      dataBuilder: (Iterable<int> ids) => <Widget>[
        ...buildPaginationSlivers<int>(
          context,
          ref,
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
