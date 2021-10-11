import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/app_theme.dart';

enum DarkTheme {
  grey,
  black,
  space,
}

extension DarkThemeExtension on DarkTheme {
  String title(BuildContext context) {
    switch (this) {
      case DarkTheme.grey:
        return AppLocalizations.of(context)!.grey;
      case DarkTheme.black:
        return AppLocalizations.of(context)!.black;
      case DarkTheme.space:
        return AppLocalizations.of(context)!.space;
    }
  }

  Color get color {
    switch (this) {
      case DarkTheme.grey:
        return AppTheme.darkBackgroundColor;
      case DarkTheme.black:
        return AppTheme.blackBackgroundColor;
      case DarkTheme.space:
        return AppTheme.spaceBackgroundColor;
    }
  }

  ThemeData theme(Color color) {
    switch (this) {
      case DarkTheme.grey:
        return AppTheme.darkTheme(color);
      case DarkTheme.black:
        return AppTheme.blackTheme(color);
      case DarkTheme.space:
        return AppTheme.spaceTheme(color);
    }
  }
}
