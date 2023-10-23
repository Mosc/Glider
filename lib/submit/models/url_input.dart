import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

enum UrlValidationError { empty, invalid }

extension UrlValidationErrorExtension on UrlValidationError {
  String label(BuildContext context, {required String otherField}) {
    return switch (this) {
      UrlValidationError.empty => context.l10n.bothEmptyError(otherField),
      UrlValidationError.invalid => context.l10n.invalidUrlError,
    };
  }
}

final class UrlInput extends FormzInput<String, UrlValidationError> {
  const UrlInput.pure(super.value, {this.text = ''}) : super.pure();

  const UrlInput.dirty(super.value, {required this.text}) : super.dirty();

  final String text;

  @override
  UrlValidationError? validator(String value) => switch (value) {
        final url when url.isEmpty && text.isEmpty => UrlValidationError.empty,
        final url when url.isNotEmpty && !hasHost => UrlValidationError.invalid,
        _ => null,
      };

  bool get hasHost => Uri.tryParse(value)?.host.isNotEmpty ?? false;
}
