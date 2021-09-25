import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum AccountMenuAction {
  synchronize,
  logOut,
}

extension StoriesMenuActionExtension on AccountMenuAction {
  String title(BuildContext context) {
    switch (this) {
      case AccountMenuAction.synchronize:
        return AppLocalizations.of(context)!.synchronize;
      case AccountMenuAction.logOut:
        return AppLocalizations.of(context)!.logOut;
    }
  }
}
