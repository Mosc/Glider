import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/pages/favorites_search_page.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/utils/async_notifier.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/block.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/common/sliver_smooth_animated_list.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesSearchBody extends HookConsumerWidget {
  const FavoritesSearchBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoDisposeStateNotifierProvider<AsyncNotifier<Iterable<int>>,
        AsyncValue<Iterable<int>>> provider = itemIdsSearchNotifierProvider(
      SearchParameters.favorites(
        query: ref.watch(favoriteSearchQueryStateProvider),
        order: ref.watch(favoriteSearchOrderStateProvider),
        favoriteIds: ref.watch(favoriteIdsNotifierProvider).value ?? <int>[],
      ),
    );

    return RefreshableBody<Iterable<int>>(
      provider: provider,
      onRefresh: () => ref.read(provider.notifier).forceLoad(),
      loadingBuilder: () => <Widget>[
        SliverToBoxAdapter(child: _buildOnlyStoriesSearched(context)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, __) => const CommentTileLoading(),
          ),
        ),
      ],
      dataBuilder: (Iterable<int> ids) => <Widget>[
        SliverToBoxAdapter(child: _buildOnlyStoriesSearched(context)),
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

  Widget _buildOnlyStoriesSearched(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Block(
        child: Row(
          children: <Widget>[
            Icon(
              FluentIcons.info_24_regular,
              size: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.scaledFontSize(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context).favoritesOnlyStoriesSearched,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
