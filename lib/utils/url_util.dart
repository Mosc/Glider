import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:native_launcher/native_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  UrlUtil._();

  static Future<bool> tryLaunch(BuildContext context, String urlString) async {
    return await _tryLaunchNonBrowser(urlString) ||
        await _tryLaunchCustomTab(context, urlString) ||
        await _tryLaunchPlatform(urlString);
  }

  static Future<bool> _tryLaunchNonBrowser(String urlString) async {
    try {
      return await NativeLauncher.launchNonBrowser(urlString) ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<bool> _tryLaunchCustomTab(
      BuildContext context, String urlString) async {
    try {
      await FlutterWebBrowser.openWebPage(
        url: urlString,
        customTabsOptions: CustomTabsOptions(
          toolbarColor: Theme.of(context).appBarTheme.color,
          addDefaultShareMenuItem: true,
          showTitle: true,
        ),
        safariVCOptions: SafariViewControllerOptions(
          barCollapsingEnabled: true,
          preferredBarTintColor: Theme.of(context).appBarTheme.color,
          preferredControlTintColor:
              Theme.of(context).appBarTheme.iconTheme?.color,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
      return true;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<bool> _tryLaunchPlatform(String urlString) async {
    if (await canLaunch(urlString)) {
      return launch(urlString);
    }

    return false;
  }
}
