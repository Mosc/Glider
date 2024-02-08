import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class WallabagApiService {
  WallabagApiService(this._authorizedClient, this._wallabagEndpoint);

  final http.Client _authorizedClient;
  final Uri _wallabagEndpoint;

  Future<String?> currentUser() async {
    final response = await _authorizedClient
        .get(
          _wallabagEndpoint.replace(
            path: '/api/user',
          ),
        )
        .then((response) => jsonDecode(response.body) as Map<String, dynamic>);

    return response['username'] as String?;
  }

  Future<bool> entryExists(Uri url) async {
    final urlDigest = sha1.convert(utf8.encode(url.toString()));

    final response = await _authorizedClient
        .get(
          _wallabagEndpoint.replace(
            path: '/api/entries/exists',
            queryParameters: {'hashed_url': urlDigest.toString()},
          ),
        )
        .then((response) => jsonDecode(response.body) as Map<String, dynamic>);

    return response['exists'] == true;
  }

  Future<int?> entryAdd({
    required Uri articleUrl,
    String? commaSeparatedTags,
    Uri? originUrl,
    String? title,
  }) async {
    final response = await _authorizedClient.post(
      _wallabagEndpoint.replace(path: '/api/entries'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'url': articleUrl.toString(),
        if (commaSeparatedTags != null && commaSeparatedTags.isNotEmpty)
          'tags': commaSeparatedTags,
        if (originUrl != null) 'origin_url': originUrl.toString(),
        if (title != null && title.isNotEmpty) 'title': title,
      },
    ).then((response) => jsonDecode(response.body) as Map<String, dynamic>);

    return int.tryParse(response['http_status'] as String? ?? '');
  }
}
