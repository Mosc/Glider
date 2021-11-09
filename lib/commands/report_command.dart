import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:glider/utils/url_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReportCommand with CommandMixin {
  const ReportCommand(this.context, this.ref, {required this.id});

  final BuildContext context;
  final WidgetRef ref;
  final String id;

  @override
  Future<void> execute() async {
    final bool success = await UrlUtil.tryLaunch(
      context,
      ref,
      Uri(
        scheme: 'mailto',
        path: 'yclegal@ycombinator.com',
        query: 'subject=${Uri.encodeComponent('Report user $id')}',
      ).toString(),
    );

    if (!success) {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
      );
    }
  }
}
