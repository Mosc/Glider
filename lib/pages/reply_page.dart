import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/utils/app_bar_util.dart';
import 'package:glider/widgets/reply/reply_body.dart';

class ReplyPage extends HookWidget {
  const ReplyPage({Key key, @required this.replyToItem, this.rootId})
      : super(key: key);

  final Item replyToItem;
  final int rootId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBarUtil.buildFluentIconsLeading(context),
        title: const Text('Reply'),
      ),
      body: ReplyBody(replyToItem: replyToItem, rootId: rootId),
    );
  }
}
