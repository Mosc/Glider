import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/models/item_menu_action.dart';
import 'package:glider/pages/item_search_page.dart';
import 'package:glider/providers/item_provider.dart';
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

    final AsyncData<Item>? itemData = ref.watch(itemNotifierProvider(id)).data;

    return Scaffold(
      body: FloatingAppBarScrollView(
        actions: <Widget>[
          if (itemData != null && itemData.value.parent == null)
            IconButton(
              icon: const Icon(FluentIcons.search_24_regular),
              tooltip: AppLocalizations.of(context)!.search,
              onPressed: () => _searchSelected(context, ref),
            ),
          PopupMenuButton<ItemMenuAction>(
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ItemMenuAction>>[
              for (ItemMenuAction menuAction in ItemMenuAction.values)
                if (menuAction.visible(context, ref, id: id))
                  PopupMenuItem<ItemMenuAction>(
                    value: menuAction,
                    child: Text(menuAction.title(context, ref, id: id)),
                  ),
            ],
            onSelected: (ItemMenuAction menuAction) =>
                menuAction.command(context, ref, id: id, rootId: id).execute(),
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

  Future<void> _searchSelected(BuildContext context, WidgetRef ref) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ItemSearchPage(storyId: id),
      ),
    );
  }
}
