import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  UrlUtil._();

  static Future<void> tryLaunch(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(urlString);
    }
  }
}
