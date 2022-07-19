import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TextSize {
  small,
  medium,
  large,
}

extension TextSizeExtension on TextSize {
  String title(BuildContext context) {
    switch (this) {
      case TextSize.small:
        return AppLocalizations.of(context).small;
      case TextSize.medium:
        return AppLocalizations.of(context).medium;
      case TextSize.large:
        return AppLocalizations.of(context).large;
    }
  }

  double get scaleFactor {
    switch (this) {
      case TextSize.small:
        return 0.85;
      case TextSize.medium:
        return 1;
      case TextSize.large:
        return 1.15;
    }
  }
}
