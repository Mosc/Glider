import 'package:flutter/widgets.dart';
import 'package:glider/l10n/app_localizations.dart';

enum StoriesMenuAction {
  catchUp,
  favorites,
  submit,
  appearance,
  account,
}

extension StoriesMenuActionExtension on StoriesMenuAction {
  String title(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (this) {
      case StoriesMenuAction.catchUp:
        return appLocalizations.catchUp;
      case StoriesMenuAction.favorites:
        return appLocalizations.favorites;
      case StoriesMenuAction.submit:
        return appLocalizations.submit;
      case StoriesMenuAction.appearance:
        return appLocalizations.appearance;
      case StoriesMenuAction.account:
        return appLocalizations.account;
    }
  }
}
