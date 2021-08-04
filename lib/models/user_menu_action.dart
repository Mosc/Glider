import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/commands/user_options_command.dart';

enum UserMenuAction {
  copy,
  share,
}

extension UserMenuActionExtension on UserMenuAction {
  String title(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (this) {
      case UserMenuAction.copy:
        return appLocalizations.copy;
      case UserMenuAction.share:
        return appLocalizations.share;
    }
  }

  Command command(BuildContext context, {required String id}) {
    switch (this) {
      case UserMenuAction.copy:
        return UserOptionsCommand.copy(context, id: id);
      case UserMenuAction.share:
        return UserOptionsCommand.share(context, id: id);
    }
  }
}
