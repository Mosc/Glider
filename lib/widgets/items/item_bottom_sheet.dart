import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glider/models/item_menu_action.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemBottomSheet extends HookConsumerWidget {
  const ItemBottomSheet({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableBottomSheet(
      children: <Widget>[
        for (ItemMenuAction menuAction in ItemMenuAction.values)
          if (menuAction.visible(context, ref, id: id))
            ListTile(
              leading: Icon(menuAction.icon(context, ref, id: id)),
              title: Text(menuAction.title(context, ref, id: id)),
              onTap: () async {
                Navigator.of(context).pop();
                unawaited(menuAction.command(context, ref, id: id).execute());
              },
            ),
      ],
    );
  }
}
