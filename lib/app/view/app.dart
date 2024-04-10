import 'package:device_info_plus/device_info_plus.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glider/app/extensions/theme_mode_extension.dart';
import 'package:glider/app/extensions/variant_extension.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/settings/cubit/settings_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relative_time/relative_time.dart';

class App extends StatelessWidget {
  const App(
    this._settingsCubit,
    this._routerConfig,
    this._deviceInfo, {
    super.key,
  });

  final SettingsCubit _settingsCubit;
  final RouterConfig<Object> _routerConfig;
  final BaseDeviceInfo _deviceInfo;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) =>
          BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _settingsCubit,
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode ||
            previous.useDynamicTheme != current.useDynamicTheme ||
            previous.themeColor != current.themeColor ||
            previous.themeVariant != current.themeVariant ||
            previous.usePureBackground != current.usePureBackground ||
            previous.font != current.font,
        builder: (context, state) => MaterialApp.router(
          routerConfig: _routerConfig,
          theme: _buildTheme(context, state, lightDynamic, Brightness.light),
          darkTheme: _buildTheme(context, state, darkDynamic, Brightness.dark),
          themeMode: state.themeMode.toMaterialThemeMode(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            RelativeTimeLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          scrollBehavior: _AppScrollBehavior(_deviceInfo),
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
    final colorScheme = switch (state) {
      SettingsState(useDynamicTheme: true) when dynamicColorScheme != null =>
        dynamicColorScheme,
      SettingsState(useDynamicTheme: true) => ColorScheme.fromSeed(
          seedColor: state.themeColor,
          brightness: brightness,
        ),
      final state => state.themeVariant.toColorScheme(
          state.themeColor,
          brightness,
        ),
    }
        .copyWith(
      surface: state.usePureBackground
          ? brightness == Brightness.dark
              ? Colors.black
              : Colors.white
          : null,
    );
    return ThemeData(
      visualDensity: VisualDensity.comfortable,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: GoogleFonts.getTextTheme(state.font, const TextTheme()),
      appBarTheme: AppBarTheme(
        color: colorScheme.surface,
        centerTitle: false,
      ),
      badgeTheme: BadgeThemeData(
        // Badges do not handle text scaling by default.
        smallSize: MediaQuery.textScalerOf(context).scale(6),
        largeSize: MediaQuery.textScalerOf(context).scale(16),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        // Material 3 dictates a maximum width for bottom sheets.
        constraints: BoxConstraints(maxWidth: 640),
      ),
      cardTheme: const CardTheme(
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(filled: true),
      menuButtonTheme: const MenuButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(
            AppSpacing.defaultTilePadding,
          ),
        ),
      ),
      menuTheme: const MenuThemeData(
        style: MenuStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSpacing.m)),
            ),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
      searchViewTheme: SearchViewThemeData(
        backgroundColor: colorScheme.surface,
      ),
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior(this._deviceInfo);

  final BaseDeviceInfo _deviceInfo;

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

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return switch (getPlatform(context)) {
      TargetPlatform.iOS ||
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows =>
        child,
      TargetPlatform.android
          when _deviceInfo is AndroidDeviceInfo &&
              _deviceInfo.version.sdkInt >= 31 =>
        StretchingOverscrollIndicator(
          axisDirection: details.direction,
          clipBehavior: details.decorationClipBehavior ?? Clip.hardEdge,
          child: child,
        ),
      _ => GlowingOverscrollIndicator(
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          child: child,
        ),
    };
  }
}
