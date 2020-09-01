import 'package:flutter/material.dart';
import 'package:glider/pages/stories_page.dart';
import 'package:glider/theme.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StoriesPage(),
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
