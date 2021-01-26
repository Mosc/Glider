import 'package:flutter/material.dart';

Color get _primaryColor => Colors.red[300];
Color get _secondaryColor => _primaryColor;
Color get _surfaceColor => Colors.grey.withOpacity(0.15);

ThemeData get lightTheme => ThemeData(
      brightness: Brightness.light,
      primaryColor: _primaryColor,
      accentColor: _secondaryColor,
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      appBarTheme: const AppBarTheme(
        brightness: Brightness.dark,
      ),
      chipTheme: ChipThemeData.fromDefaults(
        brightness: Brightness.light,
        secondaryColor: _secondaryColor,
        labelStyle: const TextStyle(),
      ).copyWith(
        backgroundColor: Colors.transparent,
        selectedColor: Colors.transparent,
        side: _StateBorderSide(),
      ),
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        onSecondary: Colors.white,
      ),
    );

ThemeData get darkTheme => ThemeData(
      brightness: Brightness.dark,
      primaryColor: _primaryColor,
      accentColor: _secondaryColor,
      scaffoldBackgroundColor: Colors.grey[900],
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      toggleableActiveColor: _primaryColor,
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        color: Colors.grey[900],
      ),
      chipTheme: ChipThemeData.fromDefaults(
        brightness: Brightness.dark,
        secondaryColor: _secondaryColor,
        labelStyle: const TextStyle(),
      ).copyWith(
        backgroundColor: Colors.transparent,
        selectedColor: Colors.transparent,
        side: _StateBorderSide(),
      ),
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
    );

class _StateBorderSide extends MaterialStateBorderSide {
  @override
  BorderSide resolve(Set<MaterialState> states) {
    return BorderSide(
      color: states.contains(MaterialState.selected)
          ? _primaryColor
          : _surfaceColor,
    );
  }
}
