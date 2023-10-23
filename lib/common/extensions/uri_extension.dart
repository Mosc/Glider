import 'package:url_launcher/url_launcher.dart';

extension UriExtension on Uri {
  Future<bool> tryLaunch({String? title}) async {
    if (await canLaunchUrl(this)) {
      final success = await launchUrl(
        this,
        mode: LaunchMode.externalNonBrowserApplication,
        webOnlyWindowName: title,
      );

      if (!success) {
        await launchUrl(
          this,
          mode: LaunchMode.inAppWebView,
          webOnlyWindowName: title,
        );
      }

      return true;
    }

    return false;
  }
}
