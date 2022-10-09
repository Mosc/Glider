import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/async_state_notifier.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VoteCommand with CommandMixin {
  const VoteCommand(this.context, this.ref,
      {required this.id, required this.upvote});

  final BuildContext context;
  final WidgetRef ref;
  final int id;
  final bool upvote;

  @override
  Future<void> execute() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final AsyncStateNotifier<Item> itemNotifier =
          ref.read(itemNotifierProvider(id).notifier);
      unawaited(_vote(authRepository, itemNotifier));
    } else {
      final NavigatorState navigator = Navigator.of(context);
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).voteNotLoggedIn),
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

  Future<void> _vote(AuthRepository authRepository,
      AsyncStateNotifier<Item> itemNotifier) async {
    final bool success = await authRepository.vote(
      id: id,
      value: upvote,
      onUpdate: () => ref.invalidate(upvotedProvider(id)),
    );

    if (success) {
      final Item item = await itemNotifier.forceLoad();
      final int? score = item.score;

      if (score != null) {
        itemNotifier.setData(item.copyWith(score: score + (upvote ? 1 : -1)));
      }
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).genericError)),
      );
    }
  }
}
