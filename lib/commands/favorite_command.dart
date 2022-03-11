import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoriteCommand with CommandMixin {
  const FavoriteCommand(BuildContext _, this.ref,
      {required this.id, required this.favorite});

  final WidgetRef ref;
  final int id;
  final bool favorite;

  @override
  Future<void> execute() async {
    unawaited(
      ref.read(authRepositoryProvider).favorite(
            id: id,
            value: favorite,
            onUpdate: () {
              ref.invalidate(favoritedProvider(id));
              ref.read(favoriteIdsNotifierProvider.notifier).forceLoad();
            },
          ),
    );
  }
}
