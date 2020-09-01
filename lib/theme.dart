import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color get _primaryColor => Colors.red[300];
Color get _surfaceColor => Colors.grey.withOpacity(0.1);

ThemeData get lightTheme => ThemeData(
      brightness: Brightness.light,
      primaryColor: _primaryColor,
      accentColor: _primaryColor,
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _primaryColor,
        surface: _surfaceColor,
      ),
    );

ThemeData get darkTheme => ThemeData(
      brightness: Brightness.dark,
      primaryColor: _primaryColor,
      accentColor: _primaryColor,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(color: Colors.grey[850]),
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        secondary: _primaryColor,
        surface: _surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
    );
