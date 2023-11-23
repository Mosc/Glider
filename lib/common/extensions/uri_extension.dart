import 'package:url_launcher/url_launcher.dart';

extension UriExtension on Uri {
  Future<bool> tryLaunch({String? title, required bool useInAppBrowser}) async {
    if (await canLaunchUrl(this)) {
      if (useInAppBrowser &&
          await supportsLaunchMode(LaunchMode.inAppBrowserView)) {
        final success = await launchUrl(
          this,
          mode: LaunchMode.inAppBrowserView,
          webOnlyWindowName: title,
        );
        if (success) return true;
      }

      if (await supportsLaunchMode(LaunchMode.externalNonBrowserApplication)) {
        final success = await launchUrl(
          this,
          mode: LaunchMode.externalNonBrowserApplication,
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
