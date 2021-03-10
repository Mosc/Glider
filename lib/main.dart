import 'package:flutter/material.dart';
import 'package:glider/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';

Future<void> main() async {
  await Jiffy.locale();
  runApp(const ProviderScope(child: App()));
}
