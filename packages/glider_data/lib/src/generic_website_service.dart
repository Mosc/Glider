import 'package:compute/compute.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class GenericWebsiteService {
  const GenericWebsiteService(this._client);

  final http.Client _client;

  Future<String?> getTitle(Uri url) async {
    final response = await _client.get(url);
    return compute(
      (body) => html_parser.parse(body).querySelector('title')?.text,
      response.body,
    );
  }
}
