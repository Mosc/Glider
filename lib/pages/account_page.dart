import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/account_menu_action.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/account/account_body.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/synchronize/synchronize_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountPage extends HookWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AsyncData<bool>? loggedIn = useProvider(loggedInProvider).data;

    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(appLocalizations.account),
        actions: loggedIn?.value ?? false
            ? <Widget>[
                PopupMenuButton<AccountMenuAction>(
                  itemBuilder: (_) => <PopupMenuEntry<AccountMenuAction>>[
                    for (AccountMenuAction menuAction
                        in AccountMenuAction.values)
                      PopupMenuItem<AccountMenuAction>(
                        value: menuAction,
                        child: Text(menuAction.title(context)),
                      ),
                  ],
                  onSelected: (AccountMenuAction menuAction) async {
                    switch (menuAction) {
                      case AccountMenuAction.synchronize:
                        return _synchronizeSelected(context);
                      case AccountMenuAction.logOut:
                        return _logOutSelected(context);
                    }
                  },
                  icon: const Icon(FluentIcons.more_vertical_24_regular),
                ),
              ]
            : null,
        body: const AccountBody(),
      ),
    );
  }

  Future<void> _synchronizeSelected(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => const SynchronizeDialog(),
    );
  }

  Future<void> _logOutSelected(BuildContext context) async {
    await context.read(authRepositoryProvider).logout();
    unawaited(context.refresh(loggedInProvider));
    unawaited(context.refresh(usernameProvider));
  }
}
