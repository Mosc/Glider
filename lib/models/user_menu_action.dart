import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/commands/report_command.dart';
import 'package:glider/commands/user_options_command.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum UserMenuAction {
  report,
  copy,
  share,
}

extension UserMenuActionExtension on UserMenuAction {
  String title(BuildContext context) {
    switch (this) {
      case UserMenuAction.report:
        return AppLocalizations.of(context)!.report;
      case UserMenuAction.copy:
        return AppLocalizations.of(context)!.copy;
      case UserMenuAction.share:
        return AppLocalizations.of(context)!.share;
    }
  }

  IconData get icon {
    switch (this) {
      case UserMenuAction.report:
        return FluentIcons.mail_error_24_regular;
      case UserMenuAction.copy:
        return FluentIcons.copy_24_regular;
      case UserMenuAction.share:
        return FluentIcons.share_24_regular;
    }
  }

  CommandMixin command(BuildContext context, WidgetRef ref,
      {required String id}) {
    switch (this) {
      case UserMenuAction.report:
        return ReportCommand(context, ref, id: id);
      case UserMenuAction.copy:
        return UserOptionsCommand.copy(context, ref, id: id);
      case UserMenuAction.share:
        return UserOptionsCommand.share(context, ref, id: id);
    }
  }
}
