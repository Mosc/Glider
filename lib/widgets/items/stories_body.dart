import 'package:flutter/material.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:glider/utils/pagination_mixin.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/common/walkthrough_item.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StoriesBody extends HookConsumerWidget with PaginationMixin {
  const StoriesBody({super.key});

  @override
  AutoDisposeStateProvider<int> get paginationStateProvider =>
      storyPaginationStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool completedWalkthrough =
        ref.watch(completedWalkthroughProvider).value ?? true;
    final AutoDisposeStateNotifierProvider<AsyncStateNotifier<Iterable<int>>,
            AsyncValue<Iterable<int>>> provider =
        storyIdsNotifierProvider(ref.watch(storyTypeStateProvider));

    return RefreshableBody<Iterable<int>>(
      provider: provider,
      onRefresh: () async {
        resetPagination(ref);
        await ref.read(provider.notifier).forceLoad();
      },
      loadingBuilder: () => <Widget>[
        if (!completedWalkthrough)
          const SliverToBoxAdapter(
            child: WalkthoughItem(),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => const StoryTileLoading(),
          ),
        ),
      ],
      dataBuilder: (Iterable<int> ids) => <Widget>[
        if (!completedWalkthrough)
          const SliverToBoxAdapter(
            child: WalkthoughItem(),
          ),
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
