import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static final Color defaultColor = Colors.red[300];
  static final Color surfaceColor = Colors.grey.withOpacity(0.15);
  static final Color lightBackgroundColor = Colors.grey[50];
  static final Color darkBackgroundColor = Colors.grey[900];
  static final Color blackBackgroundColor = Colors.black;

  static ThemeData lightTheme(Color color) =>
      _buildTheme(color, backgroundColor: lightBackgroundColor);

  static ThemeData darkTheme(Color color) =>
      _buildTheme(color, backgroundColor: darkBackgroundColor);

  static ThemeData blackTheme(Color color) =>
      _buildTheme(color, backgroundColor: blackBackgroundColor);

  static ThemeData _buildTheme(Color color, {@required Color backgroundColor}) {
    final Brightness brightness =
        ThemeData.estimateBrightnessForColor(backgroundColor);
    final Color onColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black;

    return ThemeData(
      brightness: brightness,
      primaryColor: color,
      accentColor: color,
      scaffoldBackgroundColor: backgroundColor,
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor:
            brightness == Brightness.dark ? backgroundColor : color,
        iconTheme: IconThemeData(
          color: brightness == Brightness.dark ? Colors.white : onColor,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      toggleableActiveColor: color,
      chipTheme: ChipThemeData.fromDefaults(
        brightness: brightness,
        secondaryColor: color,
        labelStyle: const TextStyle(),
      ).copyWith(
        backgroundColor: Colors.transparent,
        selectedColor: Colors.transparent,
        side: StateBorderSide(selectedColor: color, defaultColor: surfaceColor),
      ),
      colorScheme: brightness == Brightness.dark
          ? ColorScheme.dark(
              primary: color,
              secondary: color,
              surface: surfaceColor,
              onPrimary: onColor,
              onSecondary: onColor,
            )
          : ColorScheme.light(
              primary: color,
              secondary: color,
              surface: surfaceColor,
              onPrimary: onColor,
              onSecondary: onColor,
            ),
    );
  }
}

class StateBorderSide extends MaterialStateBorderSide {
  const StateBorderSide(
      {@required this.selectedColor, @required this.defaultColor});

  final Color selectedColor;
  final Color defaultColor;

  @override
  BorderSide resolve(Set<MaterialState> states) {
    return BorderSide(
      color: states.contains(MaterialState.selected)
          ? selectedColor
          : defaultColor,
    );
  }
}
