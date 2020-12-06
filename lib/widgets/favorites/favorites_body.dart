import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/separated_sliver_child_builder_delegate.dart';
import 'package:glider/widgets/common/separator.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesBody extends HookWidget {
  const FavoritesBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.refresh(favoriteIdsProvider),
      child: CustomScrollView(
        slivers: <Widget>[
          useProvider(favoriteIdsProvider).when(
            loading: () => SliverList(
              delegate: SeparatedSliverChildBuilderDelegate(
                itemBuilder: (_, __) => const StoryTileLoading(),
                separatorBuilder: (_, __) => const Separator(),
              ),
            ),
            error: (_, __) => const SliverFillRemaining(child: Error()),
            data: (Iterable<int> ids) => SliverList(
              delegate: SeparatedSliverChildBuilderDelegate(
                itemBuilder: (_, int index) {
                  if (index < ids.length) {
                    final int id = ids.elementAt(index);
                    return ItemTile(
                      id: id,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => ItemPage(id: id)),
                      ),
                      loading: () => const StoryTileLoading(),
                    );
                  } else {
                    return const End();
                  }
                },
                separatorBuilder: (_, __) => const Separator(),
                childCount: ids.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
