import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:glider/models/search_range.dart';
import 'package:glider/models/stories_menu_action.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/favorites_page.dart';
import 'package:glider/pages/stories_search_page.dart';
import 'package:glider/pages/submit_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/uni_links_handler.dart';
import 'package:glider/widgets/items/stories_body.dart';
import 'package:glider/widgets/theme/theme_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final AutoDisposeStateProvider<StoryType> storyTypeStateProvider =
    StateProvider.autoDispose<StoryType>(
        (ProviderReference ref) => StoryType.topStories);

class StoriesPage extends HookWidget {
  const StoriesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useMemoized(() => UniLinksHandler.init(context));
    useEffect(
      () => UniLinksHandler.dispose,
      <Object>[UniLinksHandler.uriSubscription],
    );

    final ValueNotifier<bool> speedDialVisibleState = useState(true);
    final ScrollController scrollController = useScrollController();
    useEffect(
      () {
        void onScrollForwardListener() => speedDialVisibleState.value =
            scrollController.position.userScrollDirection ==
                ScrollDirection.forward;
        scrollController.addListener(onScrollForwardListener);
        return () => scrollController.removeListener(onScrollForwardListener);
      },
      <Object>[scrollController],
    );

    final StateController<StoryType> storyTypeStateController =
        useProvider(storyTypeStateProvider);

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            leading: AppBarUtil.buildFluentIconsLeading(context),
            title: const Text('Glider'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(FluentIcons.search_24_filled),
                tooltip: 'Search',
                onPressed: () => _searchSelected(context),
              ),
              PopupMenuButton<StoriesMenuAction>(
                itemBuilder: (_) => <PopupMenuEntry<StoriesMenuAction>>[
                  for (StoriesMenuAction menuAction in StoriesMenuAction.values)
                    PopupMenuItem<StoriesMenuAction>(
                      value: menuAction,
                      child: Text(menuAction.title),
                    ),
                ],
                onSelected: (StoriesMenuAction menuAction) async {
                  switch (menuAction) {
                    case StoriesMenuAction.catchUp:
                      return _catchUpSelected(context);
                    case StoriesMenuAction.favorites:
                      return _favoritesSelected(context);
                    case StoriesMenuAction.submit:
                      return _submitSelected(context);
                    case StoriesMenuAction.theme:
                      return _themeSelected(context);
                    case StoriesMenuAction.account:
                      return _accountSelected(context);
                  }
                },
                icon: const Icon(FluentIcons.more_vertical_24_filled),
              ),
            ],
            forceElevated: innerBoxIsScrolled,
            floating: true,
            backwardsCompatibility: false,
          ),
        ],
        body: const StoriesBody(),
      ),
      floatingActionButton: Hero(
        tag: 'fab',
        child: MediaQuery(
          data: MediaQueryData(platformBrightness: theme.brightness),
          child: SpeedDial(
            children: <SpeedDialChild>[
              for (StoryType storyType in StoryType.values)
                SpeedDialChild(
                  label: storyType.title,
                  child: Icon(storyType.icon),
                  onTap: () => storyTypeStateController.state = storyType,
                ),
            ],
            visible: speedDialVisibleState.value,
            icon: storyTypeStateController.state.icon,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            animationSpeed: 100,
          ),
        ),
      ),
    );
  }

  Future<void> _searchSelected(BuildContext context) {
    context.read(storySearchRangeStateProvider).state = SearchRange.pastYear;
    return Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const StoriesSearchPage(
          initialSearchRange: SearchRange.pastYear,
        ),
        transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) =>
                FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  Future<void> _catchUpSelected(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const StoriesSearchPage(
          initialSearchRange: SearchRange.pastWeek,
          enableSearch: false,
        ),
      ),
    );
  }

  Future<void> _favoritesSelected(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const FavoritesPage(),
      ),
    );
  }

  Future<void> _submitSelected(BuildContext context) async {
    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => const SubmitPage(),
          fullscreenDialog: true,
        ),
      );

      if (success == true) {
        await context.refresh(storyIdsProvider(StoryType.newStories));
        context.read(storyTypeStateProvider).state = StoryType.newStories;
        ScaffoldMessenger.of(context).showSnackBarQuickly(
          SnackBar(
            content: const Text(
              'Processing may take a moment, '
              'consider refreshing for an updated view',
            ),
            action: SnackBarAction(
              label: 'Refresh',
              onPressed: () =>
                  context.refresh(storyIdsProvider(StoryType.newStories)),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(
          content: const Text('Log in to submit'),
          action: SnackBarAction(
            label: 'Log in',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const AccountPage(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _themeSelected(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => const ThemeDialog(),
    );
  }

  Future<void> _accountSelected(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const AccountPage(),
      ),
    );
  }
}
