import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VoteCommand implements Command {
  const VoteCommand(this.context, this.ref,
      {required this.id, required this.upvote});

  final BuildContext context;
  final WidgetRef ref;
  final int id;
  final bool upvote;

  @override
  Future<void> execute() async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = ref.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final bool success = await authRepository.vote(
        id: id,
        upvote: upvote,
        onUpdate: () => ref.refresh(upvotedProvider(id)),
      );

      if (success) {
        final Item item =
            await ref.read(itemNotifierProvider(id).notifier).load();
        final int? score = item.score;

        if (score != null) {
          ref
              .read(itemNotifierProvider(id).notifier)
              .setData(item.copyWith(score: score + (upvote ? 1 : 0)));
        }
      } else {
        ScaffoldMessenger.of(context).replaceSnackBar(
          SnackBar(content: Text(appLocalizations.genericError)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(appLocalizations.voteNotLoggedIn),
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
