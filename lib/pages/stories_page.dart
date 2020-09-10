import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/navigation_item.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/utils/uni_links_handler.dart';
import 'package:glider/widgets/items/stories_body.dart';

class StoriesPage extends HookWidget {
  const StoriesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useMemoized(() => UniLinksHandler.init(context));
    useEffect(
      () => UniLinksHandler.dispose,
      <Object>[UniLinksHandler.uriSubscription],
    );

    final ValueNotifier<NavigationItem> navigationItemNotifier =
        useState(NavigationItem.topStories);

    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            title: const Text('Glider'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const AccountPage(),
                  ),
                ),
              ),
              PopupMenuButton<NavigationItem>(
                itemBuilder: (_) => <PopupMenuEntry<NavigationItem>>[
                  for (NavigationItem navigationItem in NavigationItem.values)
                    PopupMenuItem<NavigationItem>(
                      value: navigationItem,
                      child: Text(navigationItem.title),
                    ),
                ],
                onSelected: (NavigationItem navigationItem) =>
                    navigationItemNotifier.value = navigationItem,
                icon: Icon(navigationItemNotifier.value.icon),
              ),
            ],
            forceElevated: innerBoxIsScrolled,
            floating: true,
          ),
        ],
        body: StoriesBody(navigationItem: navigationItemNotifier.value),
      ),
    );
  }
}
