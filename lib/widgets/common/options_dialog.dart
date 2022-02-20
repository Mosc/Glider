import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

Future<void> _copyAction(
    BuildContext context, OptionsDialogOption option) async {
  await Clipboard.setData(ClipboardData(text: option.text));
  ScaffoldMessenger.of(context).replaceSnackBar(
    SnackBar(
      content: Text(AppLocalizations.of(context).copySuccess(option.title)),
    ),
  );
}

Future<void> _shareAction(
    BuildContext context, OptionsDialogOption option, String? subject) async {
  await Share.share(option.text, subject: subject);
}

class OptionsDialogOption {
  const OptionsDialogOption({required this.title, required this.text});

  final String title;
  final String text;
}

class OptionsDialog extends HookConsumerWidget {
  OptionsDialog.copy(BuildContext context, {Key? key, required this.options})
      : title = AppLocalizations.of(context).copy,
        action = _copyAction,
        super(key: key);

  OptionsDialog.share(BuildContext context,
      {Key? key, required this.options, String? subject})
      : title = AppLocalizations.of(context).share,
        action = ((BuildContext context, OptionsDialogOption option) =>
            _shareAction(context, option, subject)),
        super(key: key);

  final String title;
  final Iterable<OptionsDialogOption> options;
  final Future<void> Function(BuildContext, OptionsDialogOption) action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      title: Text(title),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      children: <Widget>[
        for (OptionsDialogOption option in options)
          SimpleDialogOption(
            onPressed: () async {
              await action(context, option);
              Navigator.of(context).pop();
            },
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Text(
              option.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }
}
