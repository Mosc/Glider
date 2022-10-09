import 'package:flutter/material.dart';
import 'package:glider/models/user.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/pages/user_page.dart';
import 'package:glider/providers/user_provider.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:glider/utils/pagination_mixin.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/story_tile_loading.dart';
import 'package:glider/widgets/users/user_tile_data.dart';
import 'package:glider/widgets/users/user_tile_loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserBody extends HookConsumerWidget with PaginationMixin {
  const UserBody({super.key, required this.id});

  final String id;

  @override
  AutoDisposeStateProvider<int> get paginationStateProvider =>
      userPaginationStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StateNotifierProvider<AsyncStateNotifier<User>, AsyncValue<User>>
        provider = userNotifierProvider(id);

    return RefreshableBody<User>(
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
      dataBuilder: (User user) => <Widget>[
        SliverToBoxAdapter(child: UserTileData(user)),
        ...buildPaginationSlivers<int>(
          context,
          ref,
          items: user.submitted,
          builder: (_, int id, int index) => ItemTile(
            id: id,
            onTap: (BuildContext context) => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => ItemPage(id: id)),
            ),
            loading: ({int? indentation}) => _buildItemLoading(index + 1),
            refreshProvider: provider,
          ),
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
