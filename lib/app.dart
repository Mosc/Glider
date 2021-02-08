import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/models/theme_base.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends HookWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeBase themeBase =
        useProvider(themeBaseProvider).data?.value ?? ThemeBase.system;
    final Color themeColor =
        useProvider(themeColorProvider).data?.value ?? AppTheme.defaultColor;

    return MaterialApp(
      home: const StoriesPage(),
      theme: themeBase.lightTheme(themeColor),
      darkTheme: themeBase.darkTheme(themeColor),
      themeMode: themeBase.themeMode,
    );
  }
}
