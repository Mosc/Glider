import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item_menu_action.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/items/item_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemPage extends HookConsumerWidget {
  const ItemPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useMemoized(() => _setVisited(ref));

    final bool upvoted = ref.watch(upvotedProvider(id)).data?.value ?? false;
    final bool favorited =
        ref.watch(favoritedProvider(id)).data?.value ?? false;

    return Scaffold(
      body: FloatingAppBarScrollView(
        actions: <Widget>[
          PopupMenuButton<ItemMenuAction>(
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ItemMenuAction>>[
              for (ItemMenuAction menuAction in ItemMenuAction.values)
                PopupMenuItem<ItemMenuAction>(
                  value: menuAction,
                  child: Text(
                    menuAction.title(context,
                        upvoted: upvoted, favorited: favorited),
                  ),
                ),
            ],
            onSelected: (ItemMenuAction menuAction) => menuAction
                .command(context, ref,
                    id: id, upvoted: upvoted, favorited: favorited)
                .execute(),
            icon: const Icon(FluentIcons.more_vertical_24_regular),
          ),
        ],
        body: ItemBody(id: id),
      ),
    );
  }

  Future<void> _setVisited(WidgetRef ref) async {
    await ref.read(storageRepositoryProvider).setVisited(id: id);
    ref.refresh(visitedProvider(id));
  }
}
