import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/widgets/reply/reply_body.dart';

class ReplyPage extends HookWidget {
  const ReplyPage({Key key, @required this.parent, this.root})
      : super(key: key);

  final Item parent;
  final Item root;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, bool innerBoxIsScrolled) => <Widget>[
          SliverAppBar(
            leading: AppBarUtil.buildFluentIconsLeading(context),
            title: const Text('Reply'),
            forceElevated: innerBoxIsScrolled,
            floating: true,
            backwardsCompatibility: false,
          ),
        ],
        body: ReplyBody(parent: parent, root: root),
      ),
    );
  }
}
