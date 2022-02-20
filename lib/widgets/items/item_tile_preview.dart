import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTilePreview extends HookConsumerWidget {
  const ItemTilePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      AppLocalizations.of(context).previewDescription,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
