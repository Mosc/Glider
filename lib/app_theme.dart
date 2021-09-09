import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glider/utils/color_extension.dart';
import 'package:glider/utils/swipeable_page_route.dart';

class AppTheme {
  AppTheme._();

  static Iterable<Color> get themeColors => Colors.primaries.map(
        (MaterialColor materialColor) => <int>[300, 400, 500, 600]
            .map((int shade) => materialColor[shade]!)
            .firstWhere(
              (Color color) => color.isDark,
              orElse: () => materialColor[700]!,
            ),
      );

  static final Color defaultColor = themeColors.first;
  static final Color surfaceColor = Colors.grey.withOpacity(0.15);
  static final Color errorColor = Colors.red[400]!;
  static const Color onErrorColor = Colors.white;
  static final Color lightBackgroundColor = Colors.grey[50]!;
  static final Color darkBackgroundColor = Colors.grey[900]!;
  static const Color blackBackgroundColor = Colors.black;
  static final Color spaceBackgroundColor = Colors.blueGrey[900]!;

  static ThemeData lightTheme(Color color) =>
      _buildTheme(color, backgroundColor: lightBackgroundColor);

  static ThemeData darkTheme(Color color) =>
      _buildTheme(color, backgroundColor: darkBackgroundColor);

  static ThemeData blackTheme(Color color) =>
      _buildTheme(color, backgroundColor: blackBackgroundColor);

  static ThemeData spaceTheme(Color color) =>
      _buildTheme(color, backgroundColor: spaceBackgroundColor);

  static ThemeData _buildTheme(Color color, {required Color backgroundColor}) {
    final Brightness brightness =
        ThemeData.estimateBrightnessForColor(backgroundColor);
    final Color onColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black;
    final Color canvasColor = backgroundColor.lighten(0.05);

    return ThemeData(
      brightness: brightness,
      visualDensity: VisualDensity.standard,
      primaryColor: color,
      // ignore: deprecated_member_use
      accentColor: color,
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
      pageTransitionsTheme: PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          for (TargetPlatform targetPlatform in TargetPlatform.values)
            targetPlatform: const SwipeablePageTransitionsBuilder(),
        },
      ),
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
