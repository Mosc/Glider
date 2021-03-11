import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glider/app_theme.dart';

enum ThemeBase {
  system,
  light,
  dark,
  black,
  space,
}

extension ThemeBaseExtension on ThemeBase {
  String get title {
    switch (this) {
      case ThemeBase.system:
        return 'System';
      case ThemeBase.light:
        return 'Light';
      case ThemeBase.dark:
        return 'Dark';
      case ThemeBase.black:
        return 'Black';
      case ThemeBase.space:
        return 'Space';
    }

    throw UnsupportedError('$this does not have a title');
  }

  Color color(BuildContext context) {
    switch (this) {
      case ThemeBase.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark
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

    throw UnsupportedError('$this does not have a title');
  }

  ThemeData lightTheme(Color color) {
    switch (this) {
      case ThemeBase.system:
      case ThemeBase.light:
        return AppTheme.lightTheme(color);
      case ThemeBase.dark:
      case ThemeBase.black:
      case ThemeBase.space:
        return null;
    }

    throw UnsupportedError('$this does not have a light theme');
  }

  ThemeData darkTheme(Color color) {
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

    throw UnsupportedError('$this does not have a dark theme');
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

    throw UnsupportedError('$this does not have a theme mode');
  }
}
