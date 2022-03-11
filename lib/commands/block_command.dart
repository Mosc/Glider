import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlockCommand with CommandMixin {
  const BlockCommand(this.context, this.ref, {required this.id});

  final BuildContext context;
  final WidgetRef ref;
  final String id;

  @override
  Future<void> execute() async {
    final StorageRepository storageRepository =
        ref.read(storageRepositoryProvider);

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(AppLocalizations.of(context).blockConfirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              MaterialLocalizations.of(context).cancelButtonLabel,
            ),
          ),
          TextButton(
            onPressed: () async {
              await storageRepository.setBlocked(id: id);
              ref.invalidate(blockedProvider(id));
              Navigator.of(context).pop();
            },
            child: Text(
              MaterialLocalizations.of(context).okButtonLabel,
            ),
          ),
        ],
      ),
    );
  }
}
