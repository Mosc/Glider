import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/utils/uni_links_handler.dart';
import 'package:glider/widgets/items/stories_body.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/src/framework.dart';

final AutoDisposeStateProvider<NavigationItem> navigationItemStateProvider =
    StateProvider.autoDispose<NavigationItem>(
        (AutoDisposeProviderReference ref) => NavigationItem.topStories);

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

    final StateController<NavigationItem> navigationItemStateController =
        useProvider(navigationItemStateProvider);

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            leading: AppBarUtil.buildFluentIconsLeading(context),
            title: const Text('Glider'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(FluentIcons.person_24_filled),
                tooltip: 'Account',
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const AccountPage(),
                  ),
                ),
              ),
            ],
            forceElevated: innerBoxIsScrolled,
            floating: true,
          ),
        ],
        body: StoriesBody(scrollController: scrollController),
      ),
      floatingActionButton: SpeedDial(
        children: <SpeedDialChild>[
          for (NavigationItem navigationItem in NavigationItem.values)
            SpeedDialChild(
              label: navigationItem.title,
              child: Icon(navigationItem.icon),
              onTap: () => navigationItemStateController.state = navigationItem,
            ),
        ],
        visible: speedDialVisibleState.value,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        animationSpeed: 100,
        child: Icon(navigationItemStateController.state.icon),
      ),
    );
  }
}
