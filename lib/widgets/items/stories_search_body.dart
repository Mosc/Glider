import 'package:flutter/material.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/pages/stories_search_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:glider/utils/pagination_mixin.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoriesSearchBody extends HookConsumerWidget with PaginationMixin {
  const StoriesSearchBody({super.key});

  @override
  AutoDisposeStateProvider<int> get paginationStateProvider =>
      storySearchPaginationStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoDisposeStateNotifierProvider<AsyncStateNotifier<Iterable<int>>,
        AsyncValue<Iterable<int>>> provider = itemIdsSearchNotifierProvider(
      SearchParameters.stories(
        query: ref.watch(storySearchQueryStateProvider),
        range: ref.watch(storySearchRangeStateProvider),
        customDateTimeRange:
            ref.watch(storySearchCustomDateTimeRangeStateProvider),
        order: ref.watch(storySearchOrderStateProvider),
      ),
    );

    return RefreshableBody<Iterable<int>>(
      provider: provider,
      onRefresh: () async {
        resetPagination(ref);
        await ref.read(provider.notifier).forceLoad();
      },
      loadingBuilder: () => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => const StoryTileLoading(),
          ),
        ),
      ],
      dataBuilder: (Iterable<int> ids) => <Widget>[
        ...buildPaginationSlivers<int>(
          context,
          ref,
          items: ids,
          builder: (_, int id, __) => ItemTile(
            id: id,
            onTap: (BuildContext context) => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
            ),
            dense: true,
            fadeable: true,
            loading: ({int? indentation}) => const StoryTileLoading(),
            refreshProvider: provider,
          ),
        ),
      ],
    );
  }
}
