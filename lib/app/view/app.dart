import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glider/app/extensions/variant_extension.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:relative_time/relative_time.dart';

class App extends StatelessWidget {
  const App(this._settingsCubit, this._routerConfig, {super.key});

  final SettingsCubit _settingsCubit;
  final RouterConfig<Object> _routerConfig;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) =>
          BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        buildWhen: (previous, current) =>
            previous.useDynamicTheme != current.useDynamicTheme ||
            previous.themeColor != current.themeColor ||
            previous.themeVariant != current.themeVariant ||
            previous.usePureBackground != current.usePureBackground,
        builder: (context, state) => MaterialApp.router(
          routerConfig: _routerConfig,
          theme: _buildTheme(context, state, lightDynamic, Brightness.light),
          darkTheme: _buildTheme(context, state, darkDynamic, Brightness.dark),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            RelativeTimeLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          scrollBehavior: const _ShowScrollbarScrollBehavior(),
        ),
      ),
    );
  }

  ThemeData _buildTheme(
    BuildContext context,
    SettingsState state,
    ColorScheme? dynamicColorScheme,
    Brightness brightness,
  ) {
    // ignore: deprecated_member_use
    final textScaleFactor = MediaQuery.textScalerOf(context).textScaleFactor;
    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.comfortable,
      brightness: brightness,
      colorScheme: (state.useDynamicTheme && dynamicColorScheme != null
              ? dynamicColorScheme
              : state.themeVariant.toColorScheme(state.themeColor, brightness))
          .copyWith(
        background: state.usePureBackground
            ? brightness == Brightness.dark
                ? Colors.black
                : Colors.white
            : null,
      ),
      fontFamily: 'NotoSans',
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSpacing.m)),
            ),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(centerTitle: false),
      // Badges do not handle text scaling by default.
      badgeTheme: BadgeThemeData(
        smallSize: 6 * textScaleFactor,
        largeSize: 16 * textScaleFactor,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        // Material 3 dictates a maximum width for bottom sheets.
        constraints: BoxConstraints(maxWidth: 640),
      ),
      menuButtonTheme: const MenuButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStatePropertyAll(
            AppSpacing.defaultTilePadding,
          ),
        ),
      ),
    );
  }
}

class _ShowScrollbarScrollBehavior extends MaterialScrollBehavior {
  const _ShowScrollbarScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return switch (axisDirectionToAxis(details.direction)) {
      Axis.horizontal => child,
      Axis.vertical => Scrollbar(
          controller: details.controller,
          child: child,
        ),
    };
  }
}
