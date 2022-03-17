import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/async_notifier.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeleteCommand implements CommandMixin {
  const DeleteCommand(this.context, this.ref, {required this.id});

  final BuildContext context;
  final WidgetRef ref;
  final int id;

  @override
  Future<void> execute() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final AsyncNotifier<Item> itemNotifier =
          ref.read(itemNotifierProvider(id).notifier);

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(AppLocalizations.of(context).deleteConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                MaterialLocalizations.of(context).cancelButtonLabel,
              ),
            ),
            TextButton(
              onPressed: () async {
                unawaited(_delete(authRepository, itemNotifier));
                Navigator.of(context).pop();
              },
              child: Text(
                MaterialLocalizations.of(context).okButtonLabel,
              ),
            ),
          ],
        ),
      );
    } else {
      final NavigatorState navigator = Navigator.of(context);
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).deleteNotLoggedIn),
          action: SnackBarAction(
            label: AppLocalizations.of(context).logIn,
            onPressed: () => navigator.push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const AccountPage(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _delete(
      AuthRepository authRepository, AsyncNotifier<Item> itemNotifier) async {
    final bool success = await authRepository.delete(id: id);

    if (success) {
      final Item item = await itemNotifier.load();
      itemNotifier.setData(
        Item(
          id: item.id,
          time: item.time,
          deleted: true,
          preview: true,
        ),
      );
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).processingInfo),
          action: SnackBarAction(
            label: AppLocalizations.of(context).refresh,
            onPressed: itemNotifier.forceLoad,
          ),
        ),
      );
    }
  }
}
