import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/app/container/app_container.dart';
import 'package:glider/app/models/app_route.dart';
import 'package:glider/auth/cubit/auth_cubit.dart';
import 'package:glider/common/constants/app_animation.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';
import 'package:glider/common/mixins/data_mixin.dart';
import 'package:glider/common/models/status.dart';
import 'package:glider/common/widgets/app_bar_progress_indicator.dart';
import 'package:glider/common/widgets/refreshable_scroll_view.dart';
import 'package:glider/item/cubit/item_cubit.dart';
import 'package:glider/item/extensions/item_extension.dart';
import 'package:glider/item/models/item_action.dart';
import 'package:glider/item/models/item_style.dart';
import 'package:glider/item/widgets/item_loading_tile.dart';
import 'package:glider/item/widgets/item_tile.dart';
import 'package:glider/item_tree/cubit/item_tree_cubit.dart';
import 'package:glider/item_tree/view/sliver_item_tree_body.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:glider/story_item_search/bloc/story_item_search_bloc.dart';
import 'package:glider/story_item_search/view/story_item_search_view.dart';
import 'package:glider/story_similar/cubit/story_similar_cubit.dart';
import 'package:glider/story_similar/view/sliver_story_similar_body.dart';
import 'package:glider/wallabag/cubit/wallabag_cubit.dart';
import 'package:glider_domain/glider_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ItemPage extends StatefulWidget {
  ItemPage(
    this._itemCubitFactory,
    this._itemTreeCubitFactory,
    this._storySimilarCubitFactory,
    this._storyItemSearchBlocFactory,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit, {
    required this.id,
  }) : super(key: ValueKey(id));

  final ItemCubitFactory _itemCubitFactory;
  final ItemTreeCubitFactory _itemTreeCubitFactory;
  final StorySimilarCubitFactory _storySimilarCubitFactory;
  final StoryItemSearchBlocFactory _storyItemSearchBlocFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;
  final int id;

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late final ItemCubit _itemCubit;
  late final ItemTreeCubit _itemTreeCubit;
  late final StorySimilarCubit _storySimilarCubit;
  late final StoryItemSearchBloc _storyItemSearchBloc;
  late final ScrollController _scrollController;
  late final SliverObserverController _sliverObserverController;
  final GlobalKey _bodyKey = GlobalKey();

  int index = 0;

  @override
  void initState() {
    super.initState();
    _itemCubit = widget._itemCubitFactory(widget.id);
    unawaited(_itemCubit.visit(true));
    _itemTreeCubit = widget._itemTreeCubitFactory(widget.id);
    unawaited(_itemTreeCubit.load());
    _storySimilarCubit = widget._storySimilarCubitFactory(widget.id);
    _storyItemSearchBloc = widget._storyItemSearchBlocFactory(widget.id);
    _scrollController = ScrollController();
    _sliverObserverController =
        SliverObserverController(controller: _scrollController);
  }

  @override
  void dispose() {
    unawaited(_itemCubit.close());
    unawaited(_itemTreeCubit.close());
    unawaited(_storySimilarCubit.close());
    unawaited(_storyItemSearchBloc.close());
    _scrollController.dispose();
    super.dispose();
  }

  static double _getToolbarHeight({
    required int storyLines,
    required bool useLargeStoryStyle,
  }) =>
      (storyLines >= 0 ? storyLines : (useLargeStoryStyle ? 3 : 2)) *
          (useLargeStoryStyle ? 24 : 20) +
      44;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: widget._settingsCubit,
      buildWhen: (previous, current) =>
          previous.storyLines != current.storyLines ||
          previous.useLargeStoryStyle != current.useLargeStoryStyle ||
          previous.useThreadNavigation != current.useThreadNavigation,
      builder: (context, settingsState) => Scaffold(
        body: SliverViewObserver(
          controller: _sliverObserverController,
          leadingOffset: MediaQuery.paddingOf(context).top,
          onObserve: (observeModel) {
            final index = observeModel.displayingChildIndexList.firstOrNull;
            if (index != null) this.index = index;
          },
          child: RefreshableScrollView(
            scrollController: _scrollController,
            onRefresh: () async => unawaited(_itemTreeCubit.load()),
            toolbarHeight: _getToolbarHeight(
              storyLines: settingsState.storyLines,
              useLargeStoryStyle: settingsState.useLargeStoryStyle,
            ),
            slivers: [
              _SliverItemAppBar(
                _itemCubit,
                _itemTreeCubit,
                widget._itemCubitFactory,
                _storyItemSearchBloc,
                widget._authCubit,
                widget._settingsCubit,
                widget._wallabagCubit,
                bodyKey: _bodyKey,
                scrollController: _scrollController,
                toolbarHeight: _getToolbarHeight(
                  storyLines: settingsState.storyLines,
                  useLargeStoryStyle: settingsState.useLargeStoryStyle,
                ),
              ),
              SliverSafeArea(
                top: false,
                sliver: _SliverItemBody(
                  _itemCubit,
                  _itemTreeCubit,
                  _storySimilarCubit,
                  widget._itemCubitFactory,
                  widget._authCubit,
                  widget._settingsCubit,
                  widget._wallabagCubit,
                  key: _bodyKey,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: settingsState.useThreadNavigation
            ? Theme(
                data: Theme.of(context).copyWith(
                  floatingActionButtonTheme: Theme.of(context)
                      .floatingActionButtonTheme
                      .copyWith(
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.small(
                      heroTag: null,
                      onPressed: () {
                        final index = _itemTreeCubit.state
                            .getPreviousRootChildIndex(index: this.index);
                        if (index != null) _animateTo(index: index);
                      },
                      tooltip: context.l10n.previousRootChild,
                      child: const Icon(Icons.keyboard_arrow_up_outlined),
                    ),
                    FloatingActionButton.small(
                      heroTag: null,
                      onPressed: () {
                        final index = _itemTreeCubit.state
                            .getNextRootChildIndex(index: this.index);
                        if (index != null) _animateTo(index: index);
                      },
                      tooltip: context.l10n.nextRootChild,
                      child: const Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ].spaced(height: AppSpacing.xl),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }

  Future<void> _animateTo({required int index}) async =>
      _sliverObserverController.animateTo(
        index: index,
        duration: AppAnimation.emphasized.duration,
        curve: AppAnimation.emphasized.easing,
        offset: (targetOffset) => MediaQuery.paddingOf(context).top,
      );
}

class _SliverItemAppBar extends StatefulWidget {
  const _SliverItemAppBar(
    this._itemCubit,
    this._itemTreeCubit,
    this._itemCubitFactory,
    this._storyItemSearchBloc,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit, {
    this.bodyKey,
    this.scrollController,
    required this.toolbarHeight,
  });

  final ItemCubit _itemCubit;
  final ItemTreeCubit _itemTreeCubit;
  final ItemCubitFactory _itemCubitFactory;
  final StoryItemSearchBloc _storyItemSearchBloc;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;
  final GlobalKey? bodyKey;
  final ScrollController? scrollController;
  final double toolbarHeight;

  @override
  State<_SliverItemAppBar> createState() => _SliverItemAppBarState();
}

class _SliverItemAppBarState extends State<_SliverItemAppBar> {
  late final ValueNotifier<bool> _hasOverlapNotifier;
  RenderSliver? bodyRenderSliver;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _updateBodyRenderSliver());
    widget.scrollController?.addListener(_scrollListener);
    _hasOverlapNotifier = ValueNotifier(false);
  }

  @override
  void didUpdateWidget(covariant _SliverItemAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.bodyKey != oldWidget.bodyKey) {
      WidgetsBinding.instance
          .addPostFrameCallback((timeStamp) => _updateBodyRenderSliver());
    }

    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_scrollListener);
      widget.scrollController?.addListener(_scrollListener);
    }
  }

  // Only works if the body key already exists in the widget tree. Consider
  // scheduling a postframe callback before calling.
  void _updateBodyRenderSliver() {
    final bodyElement = widget.bodyKey?.currentContext as Element?;
    bodyRenderSliver = bodyElement?.renderObject as RenderSliver?;
  }

  void _scrollListener() {
    if (bodyRenderSliver != null) {
      // Checking the body overlap seems like it should be enough, but the
      // scroll listener has limited granularity. At the point that the scroll
      // controller offset reaches 0, the body overlap may not be fully updated.
      _hasOverlapNotifier.value = bodyRenderSliver!.constraints.overlap > 0 &&
          widget.scrollController!.offset > 0;
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_scrollListener);
    _hasOverlapNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: widget._itemCubit,
      builder: (context, state) => SliverAppBar(
        flexibleSpace: AppBarProgressIndicator(widget._itemTreeCubit),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(widget.toolbarHeight),
          child: Column(
            children: [
              if (state.data?.parentId case final parentId?)
                Padding(
                  padding: AppSpacing.defaultTilePadding.copyWith(top: 0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Hero(
                      tag: 'load_parent',
                      child: OutlinedButton.icon(
                        onPressed: () async => context.push(
                          AppRoute.item.location(
                            parameters: {'id': parentId.toString()},
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.arrow_upward_outlined),
                        label: Text(context.l10n.loadParent),
                      ),
                    ),
                  ),
                ),
              BlocBuilder<SettingsCubit, SettingsState>(
                bloc: widget._settingsCubit,
                buildWhen: (previous, current) =>
                    previous.useLargeStoryStyle != current.useLargeStoryStyle ||
                    previous.useActionButtons != current.useActionButtons,
                builder: (context, settingsState) => ValueListenableBuilder(
                  valueListenable: _hasOverlapNotifier,
                  builder: (context, hasOverlap, child) => ItemTile(
                    widget._itemCubit,
                    widget._authCubit,
                    widget._settingsCubit,
                    widget._wallabagCubit,
                    storyUsername: state.data?.storyUsername,
                    loadingType: ItemType.story,
                    showVisited: false,
                    // It's redundant to show a URL host in the title when view is
                    // scrolled, because the full URL should be visible below it.
                    style: hasOverlap ? ItemStyle.overview : ItemStyle.primary,
                    onTap: (context, item) async =>
                        widget.scrollController?.animateTo(
                      0,
                      duration: AppAnimation.emphasized.duration,
                      curve: AppAnimation.emphasized.easing,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (state.data?.parentId == null)
            _ItemSearchAnchor(
              widget._storyItemSearchBloc,
              widget._itemCubitFactory,
              widget._authCubit,
              widget._settingsCubit,
              widget._wallabagCubit,
            ),
          _ItemOverflowMenu(
            widget._itemCubit,
            widget._authCubit,
            widget._settingsCubit,
            widget._wallabagCubit,
          ),
        ],
        floating: true,
        stretch: true,
      ),
    );
  }
}

class _ItemSearchAnchor extends StatefulWidget {
  const _ItemSearchAnchor(
    this._storyItemSearchBloc,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit,
  );

  final StoryItemSearchBloc _storyItemSearchBloc;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;

  @override
  State<_ItemSearchAnchor> createState() => _ItemSearchAnchorState();
}

class _ItemSearchAnchorState extends State<_ItemSearchAnchor> {
  late final SearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController()
      ..text = widget._storyItemSearchBloc.state.searchText ?? ''
      ..addListener(
        () async => widget._storyItemSearchBloc
            .add(SetTextStoryItemSearchEvent(_searchController.text)),
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
          widget._storyItemSearchBloc.add(const LoadStoryItemSearchEvent());
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
        BlocSelector<StoryItemSearchBloc, StoryItemSearchState, Status>(
          bloc: widget._storyItemSearchBloc,
          selector: (state) => state.status,
          builder: (context, searchStatus) => AnimatedOpacity(
            opacity: searchStatus == Status.loading ? 1 : 0,
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
      viewBuilder: (suggestions) => StoryItemSearchView(
        widget._storyItemSearchBloc,
        widget._itemCubitFactory,
        widget._authCubit,
        widget._settingsCubit,
        widget._wallabagCubit,
      ),
      suggestionsBuilder: (context, controller) => [],
    );
  }
}

class _ItemOverflowMenu extends StatelessWidget {
  const _ItemOverflowMenu(
    this._itemCubit,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit,
  );

  final ItemCubit _itemCubit;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: _itemCubit,
      builder: (context, state) => BlocBuilder<AuthCubit, AuthState>(
        bloc: _authCubit,
        builder: (context, authState) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          bloc: _settingsCubit,
          builder: (context, settingsState) =>
              BlocBuilder<WallabagCubit, WallabagState>(
            bloc: _wallabagCubit,
            builder: (context, wallabagState) => MenuAnchor(
              menuChildren: [
                for (final action in ItemAction.values)
                  if (action.isVisible(
                    state,
                    authState,
                    settingsState,
                    wallabagState,
                  ))
                    if (action.options case final options?)
                      SubmenuButton(
                        menuChildren: [
                          for (final option in options)
                            if (option.isVisible(
                              state,
                              authState,
                              settingsState,
                              wallabagState,
                            ))
                              MenuItemButton(
                                onPressed: () async => action.execute(
                                  context,
                                  _itemCubit,
                                  _authCubit,
                                  _wallabagCubit,
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
                          _itemCubit,
                          _authCubit,
                          _wallabagCubit,
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
      ),
    );
  }
}

class _SliverItemBody extends StatelessWidget {
  const _SliverItemBody(
    this._itemCubit,
    this._itemTreeCubit,
    this._storySimilarCubit,
    this._itemCubitFactory,
    this._authCubit,
    this._settingsCubit,
    this._wallabagCubit, {
    super.key,
  });

  final ItemCubit _itemCubit;
  final ItemTreeCubit _itemTreeCubit;
  final StorySimilarCubit _storySimilarCubit;
  final ItemCubitFactory _itemCubitFactory;
  final AuthCubit _authCubit;
  final SettingsCubit _settingsCubit;
  final WallabagCubit _wallabagCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
      bloc: _itemCubit,
      builder: (context, state) => state.whenOrDefaultSlivers(
        loading: () => SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: ItemLoadingTile(
                type: ItemType.story,
                style: ItemStyle.secondary,
                padding: AppSpacing.defaultTilePadding.copyWith(top: 0),
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) =>
                  const ItemLoadingTile(type: ItemType.comment),
            ),
          ],
        ),
        success: () => SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: ItemTile(
                _itemCubit,
                _authCubit,
                _settingsCubit,
                _wallabagCubit,
                loadingType: state.data!.type ?? ItemType.story,
                showVisited: false,
                style: ItemStyle.secondary,
                padding: AppSpacing.defaultTilePadding.copyWith(top: 0),
              ),
            ),
            if (state.data!.type == ItemType.story)
              SliverAnimatedPaintExtent(
                duration: AppAnimation.emphasized.duration,
                curve: AppAnimation.emphasized.easing,
                child: SliverStorySimilarBody(
                  _storySimilarCubit,
                  _itemCubitFactory,
                  _authCubit,
                  _settingsCubit,
                  _wallabagCubit,
                  storyUsername: state.data?.storyUsername,
                ),
              ),
            SliverItemTreeBody(
              _itemTreeCubit,
              _itemCubitFactory,
              _authCubit,
              _settingsCubit,
              _wallabagCubit,
              childCount: state.data?.childIds?.length,
              storyUsername: state.data?.storyUsername,
            ),
            const SliverPadding(
              padding:
                  AppSpacing.twoSmallFloatingActionButtonsPageBottomPadding,
            ),
          ],
        ),
        onRetry: () async => _itemCubit.load(),
      ),
    );
  }
}
