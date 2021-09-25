import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/utils/color_extension.dart';

enum ThemeBase {
  system,
  light,
  dark,
  black,
  space,
}

extension ThemeBaseExtension on ThemeBase {
  String title(BuildContext context) {
    switch (this) {
      case ThemeBase.system:
        return AppLocalizations.of(context)!.system;
      case ThemeBase.light:
        return AppLocalizations.of(context)!.light;
      case ThemeBase.dark:
        return AppLocalizations.of(context)!.dark;
      case ThemeBase.black:
        return AppLocalizations.of(context)!.black;
      case ThemeBase.space:
        return AppLocalizations.of(context)!.space;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case ThemeBase.system:
        return MediaQuery.of(context).platformBrightness.isDark
            ? AppTheme.darkBackgroundColor
            : AppTheme.lightBackgroundColor;
      case ThemeBase.light:
        return AppTheme.lightBackgroundColor;
      case ThemeBase.dark:
        return AppTheme.darkBackgroundColor;
      case ThemeBase.black:
        return AppTheme.blackBackgroundColor;
      case ThemeBase.space:
        return AppTheme.spaceBackgroundColor;
    }
  }

  ThemeData? lightTheme(Color color) {
    switch (this) {
      case ThemeBase.system:
      case ThemeBase.light:
        return AppTheme.lightTheme(color);
      case ThemeBase.dark:
      case ThemeBase.black:
      case ThemeBase.space:
        return null;
    }
  }

  ThemeData? darkTheme(Color color) {
    switch (this) {
      case ThemeBase.system:
      case ThemeBase.dark:
        return AppTheme.darkTheme(color);
      case ThemeBase.black:
        return AppTheme.blackTheme(color);
      case ThemeBase.space:
        return AppTheme.spaceTheme(color);
      case ThemeBase.light:
        return null;
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case ThemeBase.system:
        return ThemeMode.system;
      case ThemeBase.light:
        return ThemeMode.light;
      case ThemeBase.dark:
      case ThemeBase.black:
      case ThemeBase.space:
        return ThemeMode.dark;
    }
  }
}
