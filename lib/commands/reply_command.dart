import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/reply_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReplyCommand implements Command {
  const ReplyCommand(this.context, {required this.id, this.rootId});

  final BuildContext context;
  final int id;
  final int? rootId;

  @override
  Future<void> execute() async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = context.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final Item item = await context.read(itemProvider(id).future);
      final Item? root = rootId != null
          ? await context.read(itemProvider(rootId!).future)
          : null;

      final bool success = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => ReplyPage(parent: item, root: root),
              fullscreenDialog: true,
            ),
          ) ??
          false;

      if (success && rootId != null) {
        context.refresh(itemTreeStreamProvider(rootId!));
        ScaffoldMessenger.of(context).showSnackBarQuickly(
          SnackBar(
            content: Text(appLocalizations.processingInfo),
            action: SnackBarAction(
              label: appLocalizations.refresh,
              onPressed: () async {
                await reloadItemTree(context.refresh, id: rootId!);
                return context.refresh(itemTreeStreamProvider(rootId!));
              },
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBarQuickly(
        SnackBar(
          content: Text(appLocalizations.replyNotLoggedIn),
          action: SnackBarAction(
            label: appLocalizations.logIn,
            onPressed: () => Navigator.of(context).push<void>(
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
