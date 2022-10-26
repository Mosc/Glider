import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ToggleVisitedCommand with CommandMixin {
  const ToggleVisitedCommand(BuildContext _, this.ref,
      {required this.id, required this.newVisitedState});

  final WidgetRef ref;
  final int id;
  final bool newVisitedState;

  @override
  Future<void> execute() async {
    await ref.read(storageRepositoryProvider).setVisited(
          id: id,
          value: newVisitedState,
        );
    ref.invalidate(visitedProvider(id));
  }
}
