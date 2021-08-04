import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:glider/models/user_menu_action.dart';
import 'package:glider/widgets/common/scrollable_bottom_sheet.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return ScrollableBottomSheet(
      children: <Widget>[
        for (UserMenuAction menuAction in UserMenuAction.values)
          ListTile(
            title: Text(menuAction.title(context)),
            onTap: () async {
              Navigator.of(context).pop();
              await menuAction.command(context, id: id).execute();
            },
          ),
      ],
    );
  }
}
