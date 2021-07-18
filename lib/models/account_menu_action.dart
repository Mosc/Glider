import 'package:flutter/widgets.dart';
import 'package:glider/l10n/app_localizations.dart';

enum AccountMenuAction {
  synchronize,
  logOut,
}

extension StoriesMenuActionExtension on AccountMenuAction {
  String title(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (this) {
      case AccountMenuAction.synchronize:
        return appLocalizations.synchronize;
      case AccountMenuAction.logOut:
        return appLocalizations.logOut;
    }
  }
}
