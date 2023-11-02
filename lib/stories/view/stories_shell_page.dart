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
import 'package:glider/stories/models/story_type.dart';
import 'package:glider/stories/view/stories_type_view.dart';
import 'package:glider/stories_search/bloc/stories_search_bloc.dart';
import 'package:glider/stories_search/view/stories_search_view.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';

class StoriesShellPage extends StatefulWidget {
  const StoriesShellPage(
    this._storiesCubit,
    this._storiesSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit, {
    super.key,
  });

  final StoriesCubit _storiesCubit;
  final StoriesSearchBloc _storiesSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  State<StoriesShellPage> createState() => _StoriesShellPageState();
}

class _StoriesShellPageState extends State<StoriesShellPage> {
  @override
  void initState() {
    unawaited(widget._storiesCubit.load());
    super.initState();
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
          ),
          SliverToBoxAdapter(
            child: StoriesTypeView(widget._storiesCubit),
          ),
          SliverSafeArea(
            top: false,
            sliver: _SliverStoriesBody(
              widget._storiesCubit,
              widget._itemCubitFactory,
              widget._authCubit,
              widget._settingsCubit,
            ),
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
  );

  final StoriesCubit _storiesCubit;
  final StoriesSearchBloc _storiesSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  State<_SliverStoriesAppBar> createState() => _SliverStoriesAppBarState();
}

class _SliverStoriesAppBarState extends State<_SliverStoriesAppBar> {
  late final SearchController _searchController;

  @override
  void initState() {
    _searchController = SearchController()
      ..text = widget._storiesSearchBloc.state.searchText ?? ''
      ..addListener(
        () async => widget._storiesSearchBloc
            .add(SetTextStoriesSearchEvent(_searchController.text)),
      );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(context.l10n.stories),
      flexibleSpace: AppBarProgressIndicator(widget._storiesCubit),
      actions: [
        SearchAnchor(
          searchController: _searchController,
          builder: (context, controller) => IconButton(
            onPressed: () {
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
          ),
          suggestionsBuilder: (context, controller) => [],
        ),
        BlocBuilder<AuthCubit, AuthState>(
          bloc: widget._authCubit,
          builder: (context, authState) =>
              BlocBuilder<SettingsCubit, SettingsState>(
            bloc: widget._settingsCubit,
            builder: (context, settingsState) => MenuAnchor(
              menuChildren: [
                for (final action in NavigationShellAction.values)
                  if (action.isVisible(null, authState, settingsState))
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

class _SliverStoriesBody extends StatelessWidget {
  const _SliverStoriesBody(
    this._storiesCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
  );

  final StoriesCubit _storiesCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesCubit, StoriesState>(
      bloc: _storiesCubit,
      builder: (context, state) => BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        buildWhen: (previous, current) =>
            previous.useLargeStoryStyle != current.useLargeStoryStyle ||
            previous.showStoryMetadata != current.showStoryMetadata ||
            previous.useActionButtons != current.useActionButtons ||
            previous.showJobs != current.showJobs,
        builder: (context, settingsState) => state.whenOrDefaultSlivers(
          loading: () => SliverList.builder(
            itemBuilder: (context, index) => ItemLoadingTile(
              type: ItemType.story,
              showMetadata: settingsState.showStoryMetadata,
              useLargeStoryStyle: settingsState.useLargeStoryStyle,
              style: ItemStyle.overview,
            ),
          ),
          nonEmpty: () => SliverMainAxisGroup(
            slivers: [
              SliverList.list(
                children: [
                  for (final id in state.loadedData!)
                    ItemTile.create(
                      _itemCubitFactory,
                      _authCubit,
                      _settingsCubit,
                      key: ValueKey<int>(id),
                      id: id,
                      loadingType: ItemType.story,
                      useLargeStoryStyle: settingsState.useLargeStoryStyle,
                      showMetadata: settingsState.showStoryMetadata,
                      useActionButtons: settingsState.useActionButtons,
                      showJobs: settingsState.showJobs ||
                          state.storyType == StoryType.jobStories,
                      style: ItemStyle.overview,
                      onTap: (context, item) async => context.push(
                        AppRoute.item.location(parameters: {'id': id}),
                      ),
                    ),
                ],
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
      ),
    );
  }
}
