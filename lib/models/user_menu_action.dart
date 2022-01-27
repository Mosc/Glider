import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/block_command.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/commands/user_options_command.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum UserMenuAction {
  block,
  copy,
  share,
}

extension UserMenuActionExtension on UserMenuAction {
  String title(BuildContext context) {
    switch (this) {
      case UserMenuAction.block:
        return AppLocalizations.of(context).block;
      case UserMenuAction.copy:
        return AppLocalizations.of(context).copy;
      case UserMenuAction.share:
        return AppLocalizations.of(context).share;
    }
  }

  IconData icon(BuildContext context) {
    switch (this) {
      case UserMenuAction.block:
        return FluentIcons.person_prohibited_20_regular;
      case UserMenuAction.copy:
        return Directionality.of(context) == TextDirection.rtl
            ? FluentIcons.clipboard_text_rtl_20_regular
            : FluentIcons.clipboard_text_ltr_20_regular;
      case UserMenuAction.share:
        return FluentIcons.share_20_regular;
    }
  }

  CommandMixin command(BuildContext context, WidgetRef ref,
      {required String id}) {
    switch (this) {
      case UserMenuAction.block:
        return BlockCommand(context, ref, id: id);
      case UserMenuAction.copy:
        return UserOptionsCommand.copy(context, ref, id: id);
      case UserMenuAction.share:
        return UserOptionsCommand.share(context, ref, id: id);
    }
  }
}
