import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/story_item_search/bloc/story_item_search_bloc.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class StoryItemSearchView extends StatelessWidget {
  const StoryItemSearchView(
    this._storyItemSearchBloc,
    this._itemCubitFactory,
    this._authCubit, {
    super.key,
  });

  final StoryItemSearchBloc _storyItemSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;

  @override
  Widget build(BuildContext context) {
    return RefreshableScrollView(
      onRefresh: () async =>
          _storyItemSearchBloc.add(const LoadStoryItemSearchEvent()),
      edgeOffset: 0,
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: _SliverStoryItemSearchBody(
            _storyItemSearchBloc,
            _itemCubitFactory,
            _authCubit,
          ),
        ),
      ],
    );
  }
}

class _SliverStoryItemSearchBody extends StatelessWidget {
  const _SliverStoryItemSearchBody(
    this._storyItemSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
  );

  final StoryItemSearchBloc _storyItemSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryItemSearchBloc, StoryItemSearchState>(
      bloc: _storyItemSearchBloc,
      builder: (context, state) => state.whenOrDefaultSlivers(
        nonEmpty: () => SliverList.list(
          children: [
            for (final id in state.data!)
              ItemTile.create(
                _itemCubitFactory,
                _authCubit,
                key: ValueKey<int>(id),
                id: id,
                loadingType: _storyItemSearchBloc.itemId == id
                    ? ItemType.story
                    : ItemType.comment,
                onTap: (context, item) async => context.push(
                  AppRoute.item.location(parameters: {'id': id}),
                ),
              ),
          ],
        ),
        onRetry: () async =>
            _storyItemSearchBloc.add(const LoadStoryItemSearchEvent()),
      ),
    );
  }
}
