import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/pages/favorites_search_page.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/favorites/favorites_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesPage extends HookConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(AppLocalizations.of(context).favorites),
        actions: <Widget>[
          IconButton(
            icon: const Icon(FluentIcons.search_24_regular),
            tooltip: AppLocalizations.of(context).search,
            onPressed: () => _searchSelected(context),
          ),
        ],
        body: const FavoritesBody(),
      ),
    );
  }

  Future<void> _searchSelected(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const FavoritesSearchPage(),
      ),
    );
  }
}
