import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum StoriesMenuAction {
  catchUp,
  favorites,
  inbox,
  submit,
  settings,
  account,
}

extension StoriesMenuActionExtension on StoriesMenuAction {
  String title(BuildContext context) {
    switch (this) {
      case StoriesMenuAction.catchUp:
        return AppLocalizations.of(context).catchUp;
      case StoriesMenuAction.favorites:
        return AppLocalizations.of(context).favorites;
      case StoriesMenuAction.inbox:
        return AppLocalizations.of(context).inbox;
      case StoriesMenuAction.submit:
        return AppLocalizations.of(context).submit;
      case StoriesMenuAction.settings:
        return AppLocalizations.of(context).settings;
      case StoriesMenuAction.account:
        return AppLocalizations.of(context).account;
    }
  }
}
