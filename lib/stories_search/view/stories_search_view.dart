import 'package:flutter/material.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/widgets/notification_canceler.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/stories_search/bloc/stories_search_bloc.dart';
import 'package:glider/stories_search/view/sliver_stories_search_body.dart';
import 'package:glider/stories_search/view/stories_search_range_view.dart';

class StoriesSearchView extends StatelessWidget {
  const StoriesSearchView(
    this._storiesSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final StoriesSearchBloc _storiesSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return NotificationCanceler<ScrollNotification>(
      child: RefreshableScrollView(
        onRefresh: () async =>
            _storiesSearchBloc.add(const LoadStoriesSearchEvent()),
        edgeOffset: 0,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: AppSpacing.m),
            sliver: SliverToBoxAdapter(
              child: StoriesSearchRangeView(_storiesSearchBloc),
            ),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverStoriesSearchBody(
              _storiesSearchBloc,
              _itemCubitFactory,
              _authCubit,
              _settingsCubit,
            ),
          ),
          const SliverPadding(
            padding: AppSpacing.floatingActionButtonPageBottomPadding,
          ),
        ],
      ),
    );
  }
}
