import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ItemTilePreview extends HookWidget {
  const ItemTilePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Text(
      appLocalizations.previewDescription,
      style: Theme.of(context).textTheme.caption,
    );
  }
}
