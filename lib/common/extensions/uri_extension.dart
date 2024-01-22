import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_uris.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

extension UriExtension on Uri {
  Future<bool> tryLaunch(
    BuildContext context, {
    String? title,
    required bool useInAppBrowser,
  }) async {
    if (authority == AppUris.hackerNewsUri.authority) {
      unawaited(context.push(toString()));
      return true;
    }

    if (await canLaunchUrl(this)) {
      if (await supportsLaunchMode(LaunchMode.externalNonBrowserApplication)) {
        final success = await launchUrl(
          this,
          mode: LaunchMode.externalNonBrowserApplication,
          webOnlyWindowName: title,
        );
        if (success) return true;
      }

      if (useInAppBrowser &&
          await supportsLaunchMode(LaunchMode.inAppBrowserView)) {
        final success = await launchUrl(
          this,
          mode: LaunchMode.inAppBrowserView,
          webOnlyWindowName: title,
        );
        if (success) return true;
      }

      if (await supportsLaunchMode(LaunchMode.externalApplication)) {
        final success = await launchUrl(
          this,
          mode: LaunchMode.externalApplication,
          webOnlyWindowName: title,
        );
        if (success) return true;
      }
    }

    return false;
  }
}
