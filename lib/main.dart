import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:glider/app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } on MissingPluginException {
    // Fail silently.
  }

  final BaseDeviceInfo deviceInfo = await DeviceInfoPlugin().deviceInfo;

  runApp(
    ProviderScope(
      child: App(deviceInfo),
    ),
  );
}
