import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/user_item_search/bloc/user_item_search_bloc.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class UserItemSearchView extends StatelessWidget {
  const UserItemSearchView(
    this._userItemSearchBloc,
    this._itemCubitFactory,
    this._authCubit, {
    super.key,
  });

  final UserItemSearchBloc _userItemSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;

  @override
  Widget build(BuildContext context) {
    return RefreshableScrollView(
      onRefresh: () async =>
          _userItemSearchBloc.add(const LoadUserItemSearchEvent()),
      edgeOffset: 0,
      slivers: [
        SliverSafeArea(
          top: false,
          sliver: _SliverUserItemSearchBody(
            _userItemSearchBloc,
            _itemCubitFactory,
            _authCubit,
          ),
        ),
      ],
    );
  }
}

class _SliverUserItemSearchBody extends StatelessWidget {
  const _SliverUserItemSearchBody(
    this._userItemSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
  );

  final UserItemSearchBloc _userItemSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserItemSearchBloc, UserItemSearchState>(
      bloc: _userItemSearchBloc,
      builder: (context, state) => state.whenOrDefaultSlivers(
        nonEmpty: () => SliverList.list(
          children: [
            for (final id in state.data!)
              ItemTile.create(
                _itemCubitFactory,
                _authCubit,
                key: ValueKey<int>(id),
                id: id,
                loadingType: ItemType.story,
                onTap: (context, item) async => context.push(
                  AppRoute.item.location(parameters: {'id': id}),
                ),
              ),
          ],
        ),
        onRetry: () async =>
            _userItemSearchBloc.add(const LoadUserItemSearchEvent()),
      ),
    );
  }
}
