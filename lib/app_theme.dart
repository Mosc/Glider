import 'package:flutter/material.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/utils/swipeable_page_route.dart';

class AppTheme {
  AppTheme._();

  static Iterable<Color> get themeColors => Colors.primaries.map(
        (MaterialColor materialColor) => <int>[300, 400, 500, 600]
            .map((int shade) => materialColor[shade]!)
            .firstWhere(
              (Color color) => color.isDark,
              orElse: () => materialColor.shade700,
            ),
      );

  static final Color defaultColor = themeColors.first;
  static final Color surfaceColor = Colors.grey.withOpacity(0.15);
  static final Color errorColor = Colors.red.shade400;
  static const Color onErrorColor = Colors.white;
  static final Color lightBackgroundColor = Colors.grey.shade50;
  static final Color darkBackgroundColor = Colors.grey.shade900;
  static const Color blackBackgroundColor = Colors.black;
  static const Color spaceBackgroundColor = Color(0xff242933);

  static ThemeData lightTheme(Color color, {required bool useGestures}) =>
      _buildTheme(color, backgroundColor: lightBackgroundColor, useGestures: useGestures);

  static ThemeData darkTheme(Color color, {required bool useGestures}) =>
      _buildTheme(color, backgroundColor: darkBackgroundColor, useGestures: useGestures);

  static ThemeData blackTheme(Color color, {required bool useGestures}) =>
      _buildTheme(color, backgroundColor: blackBackgroundColor, useGestures: useGestures);

  static ThemeData spaceTheme(Color color, {required bool useGestures}) =>
      _buildTheme(color, backgroundColor: spaceBackgroundColor, useGestures: useGestures);

  static ThemeData _buildTheme(Color color,
        {required Color backgroundColor, required bool useGestures}) {
    final Brightness brightness =
        ThemeData.estimateBrightnessForColor(backgroundColor);
    final Brightness colorBrightness =
        ThemeData.estimateBrightnessForColor(color);
    final Color onColor = colorBrightness.isDark ? Colors.white : Colors.black;
    final Color canvasColor = backgroundColor.lighten(0.05);

    return ThemeData(
      brightness: brightness,
      visualDensity: VisualDensity.standard,
      primaryColor: color,
      canvasColor: canvasColor,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: canvasColor,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      dialogBackgroundColor: canvasColor,
      toggleableActiveColor: color,
      chipTheme: ChipThemeData.fromDefaults(
        brightness: brightness,
        secondaryColor: color,
        labelStyle: const TextStyle(),
      ).copyWith(
        backgroundColor: backgroundColor,
        side: StateBorderSide(selectedColor: color, defaultColor: surfaceColor),
      ),
      pageTransitionsTheme: useGestures ? PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          for (TargetPlatform targetPlatform in TargetPlatform.values)
            targetPlatform: const SwipeablePageTransitionsBuilder(),
        },
      ) : null,
      appBarTheme: AppBarTheme(
        backgroundColor: brightness.isDark ? backgroundColor : color,
        iconTheme: IconThemeData(
          color: brightness.isDark ? Colors.white : onColor,
        ),
      ),
      colorScheme: brightness.isDark
          ? ColorScheme.dark(
              primary: color,
              secondary: color,
              surface: surfaceColor,
              error: errorColor,
              onPrimary: onColor,
              onSecondary: onColor,
              onError: onErrorColor,
            )
          : ColorScheme.light(
              primary: color,
              secondary: color,
              surface: surfaceColor,
              error: errorColor,
              onPrimary: onColor,
              onSecondary: onColor,
              // ignore: avoid_redundant_argument_values
              onError: onErrorColor,
            ),
    );
  }
}

class StateBorderSide extends MaterialStateBorderSide {
  const StateBorderSide(
      {required this.selectedColor, required this.defaultColor});

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

class SwipeablePageTransitionsBuilder extends PageTransitionsBuilder {
  const SwipeablePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SwipeablePageRouteMixin.buildPageTransitions<T>(
        route, context, animation, secondaryAnimation, child);
  }
}
