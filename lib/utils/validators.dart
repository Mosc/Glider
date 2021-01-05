class Validators {
  Validators._();

  static String notEmpty(String value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty.';
    }

    return null;
  }
}
