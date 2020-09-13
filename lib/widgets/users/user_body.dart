import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/user.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/user_provider.dart';
import 'package:glider/widgets/common/end.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/separated_sliver_child_builder_delegate.dart';
import 'package:glider/widgets/common/separator.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/users/user_tile_data.dart';
import 'package:glider/widgets/users/user_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserBody extends HookWidget {
  const UserBody({Key key, @required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.refresh(userProvider(id)),
      child: CustomScrollView(
        slivers: <Widget>[
          ...useProvider(userProvider(id)).when(
            loading: () => <Widget>[
              const SliverToBoxAdapter(child: UserTileLoading()),
            ],
            error: (_, __) => <Widget>[
              const SliverFillRemaining(child: Error()),
            ],
            data: (User user) {
              final int itemCount = user.submitted?.length ?? 0;
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    <Widget>[
                      UserTileData(user),
                      const Separator(),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SeparatedSliverChildBuilderDelegate(
                    itemBuilder: (_, int index) {
                      if (index < itemCount) {
                        final int id = user.submitted.elementAt(index);
                        return ItemTile(
                          id: user.submitted.elementAt(index),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) => ItemPage(id: id)),
                          ),
                          // It doesn't matter much, but each item is probably
                          // more likely to be a comment than a story.
                          loading: () => const CommentTileLoading(),
                        );
                      } else {
                        return const End();
                      }
                    },
                    separatorBuilder: (_, __) => const Separator(),
                    childCount: itemCount + 1,
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
