import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/favorites_page.dart';
import 'package:glider/pages/submit_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/uni_links_handler.dart';
import 'package:glider/widgets/common/smooth_animated_cross_fade.dart';
import 'package:glider/widgets/common/smooth_animated_switcher.dart';
import 'package:glider/widgets/items/stories_body.dart';
import 'package:hooks_riverpod/all.dart';
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

    final AsyncValue<Iterable<int>> favoritesValue =
        useProvider(favoriteIdsProvider);

    final AsyncValue<bool> loggedInValue = useProvider(loggedInProvider);

    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            leading: AppBarUtil.buildFluentIconsLeading(context),
            title: const Text('Glider'),
            actions: <Widget>[
              _buildSubmitIcon(context),
              favoritesValue.maybeWhen(
                data: (Iterable<int> favorites) => SmoothAnimatedSwitcher(
                  axis: Axis.horizontal,
                  condition: favorites.isNotEmpty,
                  child: _buildFavoritesIcon(context),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              loggedInValue.maybeWhen(
                data: (bool loggedIn) => SmoothAnimatedCrossFade(
                  condition: loggedIn,
                  trueChild: _buildAccountIcon(context, loggedIn: true),
                  falseChild: _buildAccountIcon(context, loggedIn: false),
                ),
                orElse: () => _buildAccountIcon(context, loggedIn: false),
              ),
            ],
            forceElevated: innerBoxIsScrolled,
            floating: true,
          ),
        ],
        body: const StoriesBody(),
      ),
      floatingActionButton: SpeedDial(
        children: <SpeedDialChild>[
          for (StoryType storyType in StoryType.values)
            SpeedDialChild(
              label: storyType.title,
              child: Icon(storyType.icon),
              onTap: () => storyTypeStateController.state = storyType,
            ),
        ],
        visible: speedDialVisibleState.value,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        animationSpeed: 100,
        child: Icon(storyTypeStateController.state.icon),
      ),
      extendBody: true,
    );
  }

  Widget _buildSubmitIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(FluentIcons.add_24_filled),
      tooltip: 'Submit',
      onPressed: () async {
        if (await context.read(authRepositoryProvider).loggedIn) {
          final bool success = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => const SubmitPage(),
              fullscreenDialog: true,
            ),
          );

          if (success != null && success) {
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
      },
    );
  }

  Widget _buildFavoritesIcon(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(FluentIcons.star_line_horizontal_3_24_filled),
        tooltip: 'Favorites',
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => const FavoritesPage(),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountIcon(BuildContext context, {@required bool loggedIn}) {
    return Center(
      child: IconButton(
        key: ValueKey<bool>(loggedIn),
        icon: Icon(loggedIn
            ? FluentIcons.person_available_24_filled
            : FluentIcons.person_24_filled),
        tooltip: 'Account',
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => const AccountPage(),
          ),
        ),
      ),
    );
  }
}
