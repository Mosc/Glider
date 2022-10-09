import 'package:flutter/material.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/pages/item_search_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/common/sliver_smooth_animated_list.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemSearchBody extends HookConsumerWidget {
  const ItemSearchBody({super.key, required this.storyId});

  final int storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoDisposeStateNotifierProvider<AsyncStateNotifier<Iterable<int>>,
        AsyncValue<Iterable<int>>> provider = itemIdsSearchNotifierProvider(
      SearchParameters.item(
        query: ref.watch(itemSearchQueryStateProvider),
        order: ref.watch(itemSearchOrderStateProvider),
        parentStoryId: storyId,
      ),
    );

    return RefreshableBody<Iterable<int>>(
      provider: provider,
      onRefresh: () async => ref.read(provider.notifier).forceLoad(),
      loadingBuilder: () => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => const CommentTileLoading(),
          ),
        ),
      ],
      dataBuilder: (Iterable<int> ids) => <Widget>[
        SliverSmoothAnimatedList<int>(
          items: ids,
          builder: (_, int id, __) => ItemTile(
            id: id,
            onTap: (_) => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
            ),
            loading: ({int? indentation}) => const CommentTileLoading(),
            refreshProvider: provider,
          ),
        ),
      ],
    );
  }
}
