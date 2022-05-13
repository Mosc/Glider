import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/models/item.dart';
import 'package:glider/widgets/common/floating_app_bar_scroll_view.dart';
import 'package:glider/widgets/reply/reply_body.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReplyPage extends HookConsumerWidget {
  const ReplyPage({super.key, required this.parent, this.root});

  final Item parent;
  final Item? root;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: FloatingAppBarScrollView(
        title: Text(AppLocalizations.of(context).reply),
        body: ReplyBody(parent: parent, root: root),
      ),
    );
  }
}
