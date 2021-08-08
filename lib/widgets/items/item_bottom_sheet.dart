import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:glider/models/item_menu_action.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemBottomSheet extends HookConsumerWidget {
  const ItemBottomSheet({Key? key, required this.id, this.rootId})
      : super(key: key);

  final int id;
  final int? rootId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableBottomSheet(
      children: <Widget>[
        for (ItemMenuAction menuAction in ItemMenuAction.values)
          if (menuAction.visible(context, ref, id: id))
            ListTile(
              title: Text(menuAction.title(context, ref, id: id)),
              onTap: () async {
                await menuAction
                    .command(context, ref, id: id, rootId: rootId)
                    .execute();
                Navigator.of(context).pop();
              },
            ),
      ],
    );
  }
}
