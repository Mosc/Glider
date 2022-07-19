import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/dark_theme.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension ThemeModeExtension on ThemeMode {
  String title(BuildContext context) {
    switch (this) {
      case ThemeMode.system:
        return AppLocalizations.of(context).system;
      case ThemeMode.light:
        return AppLocalizations.of(context).light;
      case ThemeMode.dark:
        return AppLocalizations.of(context).dark;
    }
  }

  Color color(BuildContext context, WidgetRef ref) {
    Color darkBackgroundColor(WidgetRef ref) =>
        (ref.read(darkThemeProvider).value ?? DarkTheme.grey).color;

    switch (this) {
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness.isDark
            ? darkBackgroundColor(ref)
            : AppTheme.lightBackgroundColor;
      case ThemeMode.light:
        return AppTheme.lightBackgroundColor;
      case ThemeMode.dark:
        return darkBackgroundColor(ref);
    }
  }
}
