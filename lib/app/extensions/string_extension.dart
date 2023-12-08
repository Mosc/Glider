extension StringExtension on String {
  bool containsWord(String other, {bool caseSensitive = true}) =>
      RegExp('\\b$other\\b', caseSensitive: caseSensitive).hasMatch(this);
}
