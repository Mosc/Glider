import 'package:flutter/material.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:go_router/go_router.dart';

class TextSelectDialog extends StatelessWidget {
  const TextSelectDialog({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.select),
      content: SingleChildScrollView(
        child: SelectionArea(child: Text(text)),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }
}
