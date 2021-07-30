import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/home.dart';
import 'package:glider/models/theme_base.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends HookWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useMemoized(
      () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
    );

    final ThemeBase themeBase =
        useProvider(themeBaseProvider).data?.value ?? ThemeBase.system;
    final Color themeColor =
        useProvider(themeColorProvider).data?.value ?? AppTheme.defaultColor;

    return MaterialApp(
      home: const Home(),
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appName,
      theme: themeBase.lightTheme(themeColor),
      darkTheme: themeBase.darkTheme(themeColor),
      themeMode: themeBase.themeMode,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
