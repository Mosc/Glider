import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:string_validator/string_validator.dart';

class Validators {
  Validators._();

  static String? notEmpty(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.notEmptyError;
    }

    return null;
  }

  static String? maxLength(BuildContext context, String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return AppLocalizations.of(context)!.maxLengthError(maxLength);
    }

    return null;
  }

  static String? url(BuildContext context, String? value) {
    if (value != null &&
        !isURL(value, <String, Object>{'requireProtocol': true})) {
      return AppLocalizations.of(context)!.urlError;
    }

    return null;
  }
}
