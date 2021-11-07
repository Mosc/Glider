import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:glider/models/user_menu_action.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserBottomSheet extends HookConsumerWidget {
  const UserBottomSheet({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollableBottomSheet(
      children: <Widget>[
        for (UserMenuAction menuAction in UserMenuAction.values)
          ListTile(
            leading: Icon(menuAction.icon),
            title: Text(menuAction.title(context)),
            onTap: () async {
              await menuAction.command(context, ref, id: id).execute();
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
