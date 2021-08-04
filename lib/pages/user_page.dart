import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/user_menu_action.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/users/user_body.dart';

class UserPage extends HookWidget {
  const UserPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(id),
        actions: <Widget>[
          PopupMenuButton<UserMenuAction>(
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<UserMenuAction>>[
              for (UserMenuAction menuAction in UserMenuAction.values)
                PopupMenuItem<UserMenuAction>(
                  value: menuAction,
                  child: Text(menuAction.title(context)),
                ),
            ],
            onSelected: (UserMenuAction menuAction) =>
                menuAction.command(context, id: id).execute(),
            icon: const Icon(FluentIcons.more_vertical_24_regular),
          ),
        ],
        body: UserBody(id: id),
      ),
    );
  }
}
