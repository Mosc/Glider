import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:glider/commands/command.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoriteCommand implements Command {
  const FavoriteCommand(this.context,
      {required this.id, required this.favorite});

  final BuildContext context;
  final int id;
  final bool favorite;

  @override
  Future<void> execute() async {
    unawaited(
      context.read(authRepositoryProvider).favorite(
            id: id,
            favorite: favorite,
            onUpdate: () => context
              ..refresh(favoritedProvider(id))
              ..refresh(favoriteIdsProvider),
          ),
    );
  }
}
