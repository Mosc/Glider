import 'package:validators/validators.dart';

class Validators {
  Validators._();

  static String notEmpty(String value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty.';
    }

    return null;
  }

  static String maxLength(String value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return 'Value must have a length less than or equal to $maxLength.';
    }

    return null;
  }

  static String url(String value) {
    if (!isURL(value, requireProtocol: true)) {
      return 'This field requires a valid URL address.';
    }

    return null;
  }
}
