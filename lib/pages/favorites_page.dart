import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/favorites/favorites_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesPage extends HookConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(appLocalizations.favorites),
        body: const FavoritesBody(),
      ),
    );
  }
}
