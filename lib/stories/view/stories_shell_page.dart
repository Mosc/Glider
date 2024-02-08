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
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/navigation_shell/models/navigation_shell_action.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/stories/cubit/stories_cubit.dart';
import 'package:glider/stories/view/stories_type_view.dart';
import 'package:glider/stories_search/bloc/stories_search_bloc.dart';
import 'package:glider/stories_search/view/stories_search_view.dart';
import 'package:glider/wallabag/cubit/wallabag_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class StoriesShellPage extends StatefulWidget {
  const StoriesShellPage(
    this._storiesCubit,
    this._storiesSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit, {
    super.key,
  });

  final StoriesCubit _storiesCubit;
  final StoriesSearchBloc _storiesSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;

  @override
  State<StoriesShellPage> createState() => _StoriesShellPageState();
}

class _StoriesShellPageState extends State<StoriesShellPage> {
  @override
  void initState() {
    super.initState();
    unawaited(widget._storiesCubit.load());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshableScrollView(
        onRefresh: () async => unawaited(widget._storiesCubit.load()),
        slivers: [
          _SliverStoriesAppBar(
            widget._storiesCubit,
            widget._storiesSearchBloc,
            widget._itemCubitFactory,
            widget._authCubit,
            widget._settingsCubit,
            widget._wallabagCubit,
          ),
          SliverSafeArea(
            top: false,
            sliver: _SliverStoriesBody(
              widget._storiesCubit,
              widget._itemCubitFactory,
              widget._authCubit,
              widget._settingsCubit,
              widget._wallabagCubit,
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

class _SliverStoriesAppBar extends StatefulWidget {
  const _SliverStoriesAppBar(
    this._storiesCubit,
    this._storiesSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit,
  );

  final StoriesCubit _storiesCubit;
  final StoriesSearchBloc _storiesSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;

  @override
  State<_SliverStoriesAppBar> createState() => _SliverStoriesAppBarState();
}

class _SliverStoriesAppBarState extends State<_SliverStoriesAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: StoriesTypeView(
        widget._storiesCubit,
        widget._settingsCubit,
      ),
      flexibleSpace: AppBarProgressIndicator(widget._storiesCubit),
      actions: [
        _StoriesSearchAnchor(
          widget._storiesSearchBloc,
          widget._itemCubitFactory,
          widget._authCubit,
          widget._settingsCubit,
          widget._wallabagCubit,
        ),
        BlocBuilder<AuthCubit, AuthState>(
          bloc: widget._authCubit,
          builder: (context, authState) =>
              BlocBuilder<SettingsCubit, SettingsState>(
            bloc: widget._settingsCubit,
            builder: (context, settingsState) => MenuAnchor(
              menuChildren: [
                for (final action in NavigationShellAction.values)
                  if (action.isVisible(null, authState, settingsState, null))
                    MenuItemButton(
                      onPressed: () async => action.execute(context),
                      child: Text(action.label(context, null)),
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
      ],
      floating: true,
    );
  }
}

class _StoriesSearchAnchor extends StatefulWidget {
  const _StoriesSearchAnchor(
    this._storiesSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit,
  );

  final StoriesSearchBloc _storiesSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;

  @override
  State<_StoriesSearchAnchor> createState() => _StoriesSearchAnchorState();
}

class _StoriesSearchAnchorState extends State<_StoriesSearchAnchor> {
  late final SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController()
      ..text = widget._storiesSearchBloc.state.searchText ?? ''
      ..addListener(
        () async => widget._storiesSearchBloc
            .add(SetTextStoriesSearchEvent(_searchController.text)),
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
          widget._storiesSearchBloc.add(const LoadStoriesSearchEvent());
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
        BlocBuilder<StoriesSearchBloc, StoriesSearchState>(
          bloc: widget._storiesSearchBloc,
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
      viewBuilder: (suggestions) => StoriesSearchView(
        widget._storiesSearchBloc,
        widget._itemCubitFactory,
        widget._authCubit,
        widget._settingsCubit,
        widget._wallabagCubit,
      ),
      suggestionsBuilder: (context, controller) => [],
    );
  }
}

class _SliverStoriesBody extends StatelessWidget {
  const _SliverStoriesBody(
    this._storiesCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit,
  );

  final StoriesCubit _storiesCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCubit, StoriesState>(
      bloc: _storiesCubit,
      builder: (context, state) => state.whenOrDefaultSlivers(
        loading: () => SliverList.builder(
          itemBuilder: (context, index) =>
              BlocBuilder<SettingsCubit, SettingsState>(
            bloc: _settingsCubit,
            builder: (context, settingsState) => ItemLoadingTile(
              type: ItemType.story,
              storyLines: settingsState.storyLines,
              useLargeStoryStyle: settingsState.useLargeStoryStyle,
              showMetadata: settingsState.showStoryMetadata,
              style: ItemStyle.overview,
            ),
          ),
        ),
        nonEmpty: () => SliverMainAxisGroup(
          slivers: [
            SliverList.builder(
              itemCount: state.loadedData!.length,
              itemBuilder: (context, index) {
                final id = state.loadedData![index];
                return ItemTile.create(
                  _itemCubitFactory,
                  _authCubit,
                  _settingsCubit,
                  _wallabagCubit,
                  id: id,
                  loadingType: ItemType.story,
                  forceShowMetadata: false,
                  style: ItemStyle.overview,
                  onTap: (context, item) async => context.push(
                    AppRoute.item.location(parameters: {'id': id}),
                  ),
                );
              },
            ),
            if (state.loadedData!.length < state.data!.length)
              SliverPadding(
                padding: AppSpacing.defaultTilePadding,
                sliver: SliverToBoxAdapter(
                  child: OutlinedButton.icon(
                    onPressed: _storiesCubit.showMore,
                    style: OutlinedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.expand_more_outlined),
                    label: Text(context.l10n.showMore),
                  ),
                ),
              ),
          ],
        ),
        onRetry: () async => _storiesCubit.load(),
      ),
    );
  }
}
