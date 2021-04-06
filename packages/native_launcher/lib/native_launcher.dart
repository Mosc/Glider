import 'dart:async';

import 'package:flutter/services.dart';

class NativeLauncher {
  static const MethodChannel _channel = MethodChannel('native_launcher');

  static Future<bool?> launchNonBrowser(String url) async {
    return _channel.invokeMethod<bool>('launchNonBrowser', <String, dynamic>{
      'url': url,
    });
  }
}
