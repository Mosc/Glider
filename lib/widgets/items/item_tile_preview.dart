import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/l10n/app_localizations.dart';

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
