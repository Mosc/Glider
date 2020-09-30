import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/widgets/users/user_body.dart';

class UserPage extends HookWidget {
  const UserPage({Key key, @required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            leading: AppBarUtil.buildFluentIconsLeading(context),
            title: Text(id),
            forceElevated: innerBoxIsScrolled,
            floating: true,
          ),
        ],
        body: UserBody(id: id),
      ),
    );
  }
}
