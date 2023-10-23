import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

enum TextValidationError { empty }

extension TextValidationErrorExtension on TextValidationError {
  String label(BuildContext context) {
    return switch (this) {
      TextValidationError.empty => context.l10n.emptyError,
    };
  }
}

final class TextInput extends FormzInput<String, TextValidationError> {
  const TextInput.pure(super.value) : super.pure();

  const TextInput.dirty(super.value) : super.dirty();

  @override
  TextValidationError? validator(String value) => switch (value) {
        final text when text.isEmpty => TextValidationError.empty,
        _ => null,
      };
}
