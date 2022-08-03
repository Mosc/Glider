import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/home.dart';
import 'package:glider/models/dark_theme.dart';
import 'package:glider/models/text_size.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:relative_time/relative_time.dart';

class App extends HookConsumerWidget {
  const App(this._deviceInfo, {super.key});

  final BaseDeviceInfo _deviceInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AndroidOverscrollIndicator? androidOverscrollIndicator = useMemoized(
      () {
        if (_deviceInfo is AndroidDeviceInfo) {
          final int? androidSdkVersion =
              (_deviceInfo as AndroidDeviceInfo).version.sdkInt;
          if (androidSdkVersion != null && androidSdkVersion >= 31) {
            return AndroidOverscrollIndicator.stretch;
          } else {
            return AndroidOverscrollIndicator.glow;
          }
        } else {
          return null;
        }
      },
    );

    final ThemeMode? themeMode = ref.watch(themeModeProvider).value;
    final DarkTheme darkTheme =
        ref.watch(darkThemeProvider).value ?? DarkTheme.grey;
    final Color themeColor =
        ref.watch(themeColorProvider).value ?? AppTheme.defaultColor;

    return MaterialApp(
      home: const Home(),
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).appName,
      builder: (BuildContext context, Widget? child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: MediaQuery.textScaleFactorOf(context) *
              (ref.watch(textScaleFactorProvider).value ??
                  TextSize.medium.scaleFactor),
        ),
        child: child!,
      ),
      theme: AppTheme.lightTheme(ref, themeColor),
      darkTheme: darkTheme.theme(ref, themeColor),
      themeMode: themeMode,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        FormBuilderLocalizations.delegate,
        RelativeTimeLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      scrollBehavior: MaterialScrollBehavior(
        // ignore: deprecated_member_use
        androidOverscrollIndicator: androidOverscrollIndicator,
      ).copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
    );
  }
}
