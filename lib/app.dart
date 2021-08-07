import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/home.dart';
import 'package:glider/models/theme_base.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:glider/utils/uni_links_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends HookConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useMemoized(FlutterDisplayMode.setHighRefreshRate);

    useMemoized(
      () => SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
    );

    useMemoized(() => UniLinksHandler.init(context));
    useEffect(
      () => UniLinksHandler.dispose,
      <Object?>[UniLinksHandler.uriSubscription],
    );

    final ThemeBase themeBase =
        ref.watch(themeBaseProvider).data?.value ?? ThemeBase.system;
    final Color themeColor =
        ref.watch(themeColorProvider).data?.value ?? AppTheme.defaultColor;

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
