import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SubmitType {
  link,
  text,
}

extension SubmitTypeExtension on SubmitType {
  String title(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    switch (this) {
      case SubmitType.link:
        return appLocalizations.link;
      case SubmitType.text:
        return appLocalizations.text;
    }
  }
}
