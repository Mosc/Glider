import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum StoriesMenuAction {
  catchUp,
  favorites,
  submit,
  appearance,
  settings,
  account,
}

extension StoriesMenuActionExtension on StoriesMenuAction {
  String title(BuildContext context) {
    switch (this) {
      case StoriesMenuAction.catchUp:
        return AppLocalizations.of(context)!.catchUp;
      case StoriesMenuAction.favorites:
        return AppLocalizations.of(context)!.favorites;
      case StoriesMenuAction.submit:
        return AppLocalizations.of(context)!.submit;
      case StoriesMenuAction.appearance:
        return AppLocalizations.of(context)!.appearance;
      case StoriesMenuAction.settings:
        return AppLocalizations.of(context)!.settings;
      case StoriesMenuAction.account:
        return AppLocalizations.of(context)!.account;
    }
  }
}
