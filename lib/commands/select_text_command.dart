import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectTextCommand with CommandMixin {
  const SelectTextCommand(this.context, this.ref, {required this.id});

  final BuildContext context;
  final WidgetRef ref;
  final int id;

  @override
  Future<void> execute() async {
    final Item item = await ref.read(itemNotifierProvider(id).notifier).load();

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SelectableText(
          FormattingUtil.convertHtmlToHackerNews(item.text!),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
  }
}
