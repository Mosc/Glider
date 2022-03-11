import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/edit_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/async_notifier.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditCommand with CommandMixin {
  const EditCommand(this.context, this.ref, {required this.id});

  final BuildContext context;
  final WidgetRef ref;
  final int id;

  @override
  Future<void> execute() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final AsyncNotifier<Item> itemNotifier =
          ref.read(itemNotifierProvider(id).notifier);
      final Item item = await itemNotifier.load();

      final bool success = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => EditPage(item: item),
              fullscreenDialog: true,
            ),
          ) ??
          false;

      if (success) {
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
    } else {
      final NavigatorState navigator = Navigator.of(context);
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).editNotLoggedIn),
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
}
