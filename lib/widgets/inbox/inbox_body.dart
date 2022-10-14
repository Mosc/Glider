import 'package:flutter/material.dart';
import 'package:glider/models/tree_item.dart';
import 'package:glider/pages/inbox_page.dart';
import 'package:glider/pages/item_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:glider/utils/pagination_mixin.dart';
import 'package:glider/widgets/common/error.dart';
import 'package:glider/widgets/common/loading.dart';
import 'package:glider/widgets/common/refreshable_body.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InboxBody extends HookConsumerWidget with PaginationMixin {
  const InboxBody({super.key});

  @override
  AutoDisposeStateProvider<int> get paginationStateProvider =>
      inboxPaginationStateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(usernameProvider).when(
          data: (String? username) => username != null
              ? _inboxDataBuilder(context, ref, username: username)
              : const Error(),
          loading: () => const Loading(),
          error: (_, __) => const Error(),
        );
  }

  Widget _inboxDataBuilder(BuildContext context, WidgetRef ref,
      {required String username}) {
    final AutoDisposeStateNotifierProvider<
            AsyncStateNotifier<Iterable<TreeItem>>,
            AsyncValue<Iterable<TreeItem>>> provider =
        itemRepliesNotifierProvider(username);

    return RefreshableBody<Iterable<TreeItem>>(
      provider: provider,
      onRefresh: () async {
        resetPagination(ref);
        await ref.read(provider.notifier).forceLoad();
      },
      loadingBuilder: () => <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => const CommentTileLoading(),
          ),
        ),
      ],
      dataBuilder: (Iterable<TreeItem> treeItems) => <Widget>[
        ...buildPaginationSlivers<TreeItem>(
          context,
          ref,
          items: treeItems,
          builder: (_, TreeItem treeItem, __) => ItemTile(
            id: treeItem.id,
            indentation: treeItem.ancestorIds.length,
            onTap: (_) => Navigator.of(context).push(
              MaterialPageRoute<void>(
                  builder: (_) => ItemPage(id: treeItem.id)),
            ),
            loading: ({int indentation = 0}) =>
                CommentTileLoading(indentation: indentation),
            refreshProvider: provider,
          ),
        ),
      ],
    );
  }
}
