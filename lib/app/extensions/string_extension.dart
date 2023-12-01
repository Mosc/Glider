extension StringExtension on String {
  bool caseInsensitiveContains(String other) =>
      toLowerCase().contains(other.toLowerCase());
}
