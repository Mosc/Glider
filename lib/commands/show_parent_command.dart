import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/widgets/items/comment_tile_loading.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShowParentCommand with CommandMixin {
  ShowParentCommand(this.context, this.ref, {required this.id});

  final BuildContext context;
  final WidgetRef ref;
  final int id;

  @override
  Future<void> execute() async {
    final Item item = await ref.read(itemNotifierProvider(id).notifier).load();

    if (item.parent != null) {
      final Item parentItem =
          await ref.read(itemNotifierProvider(item.parent!).notifier).load();

      await showDialog<void>(
        context: context,
        builder: (_) => ParentItemDialog(parentItem),
      );
    }
  }
}

class ParentItemDialog extends HookConsumerWidget {
  const ParentItemDialog(this.item, {super.key});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<Item> itemState = useState(item);

    return AlertDialog(
      content: ItemTile(
        id: itemState.value.id,
        loading: ({int? indentation}) => const CommentTileLoading(),
      ),
      contentPadding: const EdgeInsets.all(8),
      actions: <Widget>[
        if (itemState.value.parent != null)
          TextButton(
            onPressed: () async => itemState.value = await ref
                .read(itemNotifierProvider(itemState.value.parent!).notifier)
                .load(),
            child: Text(MaterialLocalizations.of(context).continueButtonLabel),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
      scrollable: true,
    );
  }
}
