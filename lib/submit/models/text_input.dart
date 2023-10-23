import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

enum TextValidationError { empty }

extension TextValidationErrorExtension on TextValidationError {
  String label(BuildContext context, {required String otherField}) {
    return switch (this) {
      TextValidationError.empty => context.l10n.bothEmptyError(otherField),
    };
  }
}

final class TextInput extends FormzInput<String, TextValidationError> {
  const TextInput.pure(super.value, {this.url = ''}) : super.pure();

  const TextInput.dirty(super.value, {required this.url}) : super.dirty();

  final String url;

  @override
  TextValidationError? validator(String value) => switch (value) {
        final text when text.isEmpty && url.isEmpty =>
          TextValidationError.empty,
        _ => null,
      };
}
