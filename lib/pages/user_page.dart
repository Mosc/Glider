import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
        body: UserBody(id: id),
      ),
    );
  }
}
