import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_animation.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/common/widgets/app_bar_progress_indicator.dart';
import 'package:glider/common/widgets/failure_widget.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/user/cubit/user_cubit.dart';
import 'package:glider/user/models/user_action.dart';
import 'package:glider/user/models/user_style.dart';
import 'package:glider/user/widgets/user_tile.dart';
import 'package:glider/user_item_search/bloc/user_item_search_bloc.dart';
import 'package:glider/user_item_search/view/user_item_search_view.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

const _toolbarHeight = 32.0;

class UserPage extends StatefulWidget {
  UserPage(
    this._userCubitFactory,
    this._itemCubitFactory,
    this._userItemSearchBlocFactory,
    this._authCubit,
    this._settingsCubit, {
    required this.username,
  }) : super(key: ValueKey(username));

  final UserCubitFactory _userCubitFactory;
  final ItemCubitFactory _itemCubitFactory;
  final UserItemSearchBlocFactory _userItemSearchBlocFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final String username;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final UserCubit _userCubit;
  late final UserItemSearchBloc _userItemSearchBloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _userCubit = widget._userCubitFactory(widget.username);
    unawaited(_userCubit.load());
    _userItemSearchBloc = widget._userItemSearchBlocFactory(widget.username);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    unawaited(_userCubit.close());
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: _userCubit,
      builder: (context, state) => BlocSelector<AuthCubit, AuthState, bool>(
        bloc: widget._authCubit,
        selector: (state) => state.username == widget.username,
        builder: (context, isLoggedInUser) => Scaffold(
          body: RefreshableScrollView(
            scrollController: _scrollController,
            onRefresh: () async => unawaited(_userCubit.load()),
            toolbarHeight: _toolbarHeight,
            slivers: [
              _SliverUserAppBar(
                _userCubit,
                widget._itemCubitFactory,
                _userItemSearchBloc,
                widget._authCubit,
                widget._settingsCubit,
                username: widget.username,
                scrollController: _scrollController,
              ),
              SliverSafeArea(
                top: false,
                sliver: _SliverUserBody(
                  _userCubit,
                  widget._itemCubitFactory,
                  widget._authCubit,
                  widget._settingsCubit,
                  isLoggedInUser: isLoggedInUser,
                ),
              ),
            ],
          ),
          floatingActionButton: isLoggedInUser
              ? FloatingActionButton.extended(
                  onPressed: state.synchronizing
                      ? null
                      : () async {
                          final confirm = await context.push<bool>(
                            AppRoute.confirmDialog.location(),
                            extra: (
                              title: context.l10n.synchronize,
                              text: context.l10n.synchronizeDescription,
                            ),
                          );
                          if (confirm ?? false) await _userCubit.synchronize();
                        },
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: AnimatedSize(
                    alignment: AlignmentDirectional.centerStart,
                    duration: AppAnimation.standard.duration,
                    curve: AppAnimation.standard.easing,
                    child: Text(
                      state.synchronizing
                          ? context.l10n.synchronizing
                          : context.l10n.synchronize,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _SliverUserAppBar extends StatelessWidget {
  const _SliverUserAppBar(
    this._userCubit,
    this._itemCubitFactory,
    this._userItemSearchBloc,
    this._authCubit,
    this._settingsCubit, {
    required this.username,
    required this.scrollController,
  });

  final UserCubit _userCubit;
  final ItemCubitFactory _itemCubitFactory;
  final UserItemSearchBloc _userItemSearchBloc;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final String username;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(username),
      flexibleSpace: AppBarProgressIndicator(_userCubit),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_toolbarHeight),
        child: UserTile(
          _userCubit,
          _authCubit,
          _settingsCubit,
          style: UserStyle.primary,
          onTap: (context, user) async => scrollController.animateTo(
            0,
            duration: AppAnimation.emphasized.duration,
            curve: AppAnimation.emphasized.easing,
          ),
        ),
      ),
      actions: [
        _UserSearchAnchor(
          _userItemSearchBloc,
          _itemCubitFactory,
          _authCubit,
          _settingsCubit,
        ),
        _UserOverflowMenu(
          _userCubit,
          _authCubit,
          _settingsCubit,
        ),
      ],
      floating: true,
    );
  }
}

class _UserSearchAnchor extends StatefulWidget {
  const _UserSearchAnchor(
    this._userItemSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
  );

  final UserItemSearchBloc _userItemSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  State<_UserSearchAnchor> createState() => _UserSearchAnchorState();
}

class _UserSearchAnchorState extends State<_UserSearchAnchor> {
  late final SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController()
      ..text = widget._userItemSearchBloc.state.searchText ?? ''
      ..addListener(
        () async => widget._userItemSearchBloc
            .add(SetTextUserItemSearchEvent(_searchController.text)),
      );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (context, controller) => IconButton(
        onPressed: () async {
          controller.openView();
          widget._userItemSearchBloc.add(const LoadUserItemSearchEvent());
        },
        tooltip: context.l10n.search,
        icon: const Icon(Icons.search_outlined),
      ),
      viewLeading: IconButton(
        onPressed: context.pop,
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: const BackButtonIcon(),
      ),
      viewTrailing: [
        BlocBuilder<UserItemSearchBloc, UserItemSearchState>(
          bloc: widget._userItemSearchBloc,
          builder: (context, state) => AnimatedOpacity(
            opacity: state.status == Status.loading ? 1 : 0,
            duration: AppAnimation.standard.duration,
            curve: AppAnimation.standard.easing,
            child: const CircularProgressIndicator.adaptive(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: _searchController.clear,
        ),
      ],
      viewBuilder: (suggestions) => UserItemSearchView(
        widget._userItemSearchBloc,
        widget._itemCubitFactory,
        widget._authCubit,
        widget._settingsCubit,
      ),
      suggestionsBuilder: (context, controller) => [],
    );
  }
}

class _UserOverflowMenu extends StatelessWidget {
  const _UserOverflowMenu(
    this._userCubit,
    this._authCubit,
    this._settingsCubit,
  );

  final UserCubit _userCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: _userCubit,
      builder: (context, state) => BlocBuilder<AuthCubit, AuthState>(
        bloc: _authCubit,
        builder: (context, authState) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          bloc: _settingsCubit,
          builder: (context, settingsState) => MenuAnchor(
            menuChildren: [
              for (final action in UserAction.values)
                if (action.isVisible(state, authState, settingsState))
                  if (action.options case final options?)
                    SubmenuButton(
                      menuChildren: [
                        for (final option in options)
                          if (option.isVisible(state, authState, settingsState))
                            MenuItemButton(
                              onPressed: () async => action.execute(
                                context,
                                _userCubit,
                                _authCubit,
                                option: option,
                              ),
                              child: Text(option.label(context, state)),
                            ),
                      ],
                      child: Text(action.label(context, state)),
                    )
                  else
                    MenuItemButton(
                      onPressed: () async => action.execute(
                        context,
                        _userCubit,
                        _authCubit,
                      ),
                      child: Text(action.label(context, state)),
                    ),
            ],
            builder: (context, controller, child) => IconButton(
              icon: Icon(Icons.adaptive.more_outlined),
              tooltip: MaterialLocalizations.of(context).showMenuTooltip,
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverUserBody extends StatelessWidget {
  const _SliverUserBody(
    this._userCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    this.isLoggedInUser = false,
  });

  final UserCubit _userCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final bool isLoggedInUser;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      bloc: _userCubit,
      builder: (context, state) => state.whenOrDefaultSlivers(
        loading: () => SliverList.builder(
          itemBuilder: (context, index) =>
              const ItemLoadingTile(type: ItemType.story),
        ),
        success: () => SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: UserTile(
                _userCubit,
                _authCubit,
                _settingsCubit,
                style: UserStyle.secondary,
                padding: AppSpacing.defaultTilePadding.copyWith(top: 0),
              ),
            ),
            if (state.data?.submittedIds case final submittedIds?)
              SliverList.builder(
                itemCount: submittedIds.length,
                itemBuilder: (context, index) {
                  final id = submittedIds[index];
                  return ItemTile.create(
                    _itemCubitFactory,
                    _authCubit,
                    _settingsCubit,
                    id: id,
                    loadingType: ItemType.story,
                    onTap: (context, item) async => context.push(
                      AppRoute.item.location(parameters: {'id': id}),
                    ),
                  );
                },
              ),
          ],
        ),
        // Data may not be available yet for newly registered users. Show a more
        // friendly message when we suspect this is the case.
        failure: isLoggedInUser
            ? () => SliverFillRemaining(
                  child: FailureWidget(
                    title: context.l10n.userUnavailable,
                    onRetry: () async => _userCubit.load(),
                  ),
                )
            : null,
        onRetry: () async => _userCubit.load(),
      ),
    );
  }
}
