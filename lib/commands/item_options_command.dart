import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/widgets/common/options_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemOptionsCommand implements Command {
  ItemOptionsCommand.copy(this.context, {required this.id})
      : optionsDialogBuilder = ((Iterable<OptionsDialogOption> options) =>
            OptionsDialog.copy(options: options));

  ItemOptionsCommand.share(this.context, {required this.id})
      : optionsDialogBuilder = ((Iterable<OptionsDialogOption> options) =>
            OptionsDialog.share(options: options));

  final BuildContext context;
  final int id;
  final Widget Function(Iterable<OptionsDialogOption>) optionsDialogBuilder;

  @override
  Future<void> execute() async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final Item item = await context.read(itemProvider(id).future);

    final List<OptionsDialogOption> optionsDialogOptions =
        <OptionsDialogOption>[
      if (item.text != null)
        OptionsDialogOption(
          title: appLocalizations.text,
          text: FormattingUtil.convertHtmlToHackerNews(item.text!),
        ),
      if (item.url != null)
        OptionsDialogOption(
          title: appLocalizations.link,
          text: item.url!,
        ),
      OptionsDialogOption(
        title: appLocalizations.threadLink,
        text: Uri.https(
          WebsiteRepository.authority,
          'item',
          <String, String>{'id': id.toString()},
        ).toString(),
      ),
    ];

    await showDialog<void>(
      context: context,
      builder: (_) => OptionsDialog.copy(
        options: optionsDialogOptions,
      ),
    );
  }
}
