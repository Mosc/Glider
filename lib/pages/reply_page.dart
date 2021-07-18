import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/l10n/app_localizations.dart';
import 'package:glider/models/item.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/reply/reply_body.dart';

class ReplyPage extends HookWidget {
  const ReplyPage({Key? key, required this.parent, this.root})
      : super(key: key);

  final Item parent;
  final Item? root;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(appLocalizations.reply),
        body: ReplyBody(parent: parent, root: root),
      ),
    );
  }
}
