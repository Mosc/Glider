import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
