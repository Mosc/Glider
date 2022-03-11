import 'dart:math';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/common/sliver_smooth_animated_list.dart';
import 'package:glider/widgets/common/walkthrough_item.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const int pageSize = 30;

class StoriesBody extends HookConsumerWidget {
  const StoriesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<int> pageState = useState(1);
    final StateController<StoryType> storyTypeStateController =
        ref.watch(storyTypeStateProvider.state);
    final bool completedWalkthrough =
        ref.watch(completedWalkthroughProvider).value ?? true;
    final bool useInfiniteScroll =
        ref.watch(useInfiniteScrollProvider).value ?? true;
    final AutoDisposeStateNotifierProvider<StoryIdsNotifier,
            AsyncValue<Iterable<int>>> provider =
        storyIdsNotifierProvider(storyTypeStateController.state);

    return RefreshableBody<Iterable<int>>(
      provider: provider,
      onRefresh: () => ref.read(provider.notifier).forceLoad(),
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
        SliverSmoothAnimatedList<int>(
          items: useInfiniteScroll
              ? ids
              : ids
                  .toList(growable: false)
                  .sublist(0, min(pageState.value * pageSize, ids.length)),
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
        if (!useInfiniteScroll && pageState.value * pageSize < ids.length)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: OutlinedButton(
                onPressed: () => pageState.value++,
                child: Text(
                  AppLocalizations.of(context)
                      .loadNextPage(pageState.value + 1),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
