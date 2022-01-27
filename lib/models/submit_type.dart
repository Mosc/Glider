import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SubmitType {
  link,
  text,
}

extension SubmitTypeExtension on SubmitType {
  String title(BuildContext context) {
    switch (this) {
      case SubmitType.link:
        return AppLocalizations.of(context).link;
      case SubmitType.text:
        return AppLocalizations.of(context).text;
    }
  }
}
