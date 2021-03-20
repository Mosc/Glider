enum SubmitType {
  url,
  text,
}

extension SubmitTypeExtension on SubmitType {
  String get title {
    switch (this) {
      case SubmitType.url:
        return 'URL';
      case SubmitType.text:
        return 'Text';
    }
  }
}
