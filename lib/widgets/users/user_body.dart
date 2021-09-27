import 'package:flutter/material.dart';
import 'package:glider/models/user.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/user_provider.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/common/sliver_smooth_animated_list.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:glider/widgets/users/user_tile_data.dart';
import 'package:glider/widgets/users/user_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserBody extends HookConsumerWidget {
  const UserBody({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshableBody<User>(
      provider: userNotifierProvider(id),
      loadingBuilder: () => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildItemLoading(index),
          ),
        ),
      ],
      dataBuilder: (User user) => <Widget>[
        SliverToBoxAdapter(child: UserTileData(user)),
        SliverSmoothAnimatedList<int>(
          items: user.submitted,
          builder: (_, int id, int index) {
            return ItemTile(
              id: id,
              onTap: (_) => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
              ),
              loading: () => _buildItemLoading(index + 1),
            );
          },
        ),
      ],
    );
  }

  Widget _buildItemLoading(int index) {
    return index == 0
        ? const UserTileLoading()
        : index.isEven
            ? const StoryTileLoading()
            : const CommentTileLoading();
  }
}
