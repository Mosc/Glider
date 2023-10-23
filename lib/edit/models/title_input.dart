import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';

enum TitleValidationError { empty, tooLong }

extension TitleValidationErrorExtension on TitleValidationError {
  String label(BuildContext context) {
    return switch (this) {
      TitleValidationError.empty => context.l10n.emptyError,
      TitleValidationError.tooLong =>
        context.l10n.tooLongError(TitleInput.maxLength),
    };
  }
}

final class TitleInput extends FormzInput<String, TitleValidationError> {
  const TitleInput.pure(super.value) : super.pure();

  const TitleInput.dirty(super.value) : super.dirty();

  static const maxLength = 80;

  @override
  TitleValidationError? validator(String value) => switch (value) {
        final title when title.isEmpty => TitleValidationError.empty,
        final title when title.length > maxLength =>
          TitleValidationError.tooLong,
        _ => null,
      };
}
