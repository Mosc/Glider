import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/widgets/common/options_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemOptionsCommand with CommandMixin {
  ItemOptionsCommand.copy(this.context, this.ref, {required this.id})
      : optionsDialogBuilder = ((Iterable<OptionsDialogOption> options) =>
            OptionsDialog.copy(context, options: options));

  ItemOptionsCommand.share(this.context, this.ref, {required this.id})
      : optionsDialogBuilder =
            ((Iterable<OptionsDialogOption> options) => OptionsDialog.share(
                  context,
                  options: options,
                  subject: ref.read(itemNotifierProvider(id)).value?.title,
                ));

  final BuildContext context;
  final WidgetRef ref;
  final int id;
  final Widget Function(Iterable<OptionsDialogOption>) optionsDialogBuilder;

  @override
  Future<void> execute() async {
    final Item item = await ref.read(itemNotifierProvider(id).notifier).load();

    final List<OptionsDialogOption> optionsDialogOptions =
        <OptionsDialogOption>[
      if (item.text?.isNotEmpty ?? false)
        OptionsDialogOption(
          title: AppLocalizations.of(context).text,
          text: FormattingUtil.convertHtmlToHackerNews(item.text!),
        ),
      if (item.url?.isNotEmpty ?? false)
        OptionsDialogOption(
          title: AppLocalizations.of(context).link,
          text: item.url!,
        ),
      OptionsDialogOption(
        title: AppLocalizations.of(context).threadLink,
        text: Uri.https(
          WebsiteRepository.authority,
          'item',
          <String, String>{'id': id.toString()},
        ).toString(),
      ),
    ];

    await showDialog<void>(
      context: context,
      builder: (_) => optionsDialogBuilder(optionsDialogOptions),
    );
  }
}
