import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:string_validator/string_validator.dart';

class Validators {
  Validators._();

  static String? notEmpty(BuildContext context, String? value) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return appLocalizations.notEmptyError;
    }

    return null;
  }

  static String? maxLength(BuildContext context, String? value, int maxLength) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (value != null && value.length > maxLength) {
      return appLocalizations.maxLengthError(maxLength);
    }

    return null;
  }

  static String? url(BuildContext context, String? value) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    if (value != null &&
        !isURL(value, <String, Object>{'requireProtocol': true})) {
      return appLocalizations.urlError;
    }

    return null;
  }
}
