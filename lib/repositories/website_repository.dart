import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:glider/models/post_data.dart';

class WebsiteRepository {
  const WebsiteRepository(this._dio);

  static const String baseUrl = 'https://news.ycombinator.com';

  final Dio _dio;

  Future<bool> register({
    @required String username,
    @required String password,
  }) async {
    const String url = '$baseUrl/login';
    final PostData postData = PostData(
      acct: username,
      pw: password,
      creating: 't',
      goto: 'news',
    );

    return _performPost(url, postData);
  }

  Future<bool> login({
    @required String username,
    @required String password,
  }) async {
    const String url = '$baseUrl/login';
    final PostData postData = PostData(
      acct: username,
      pw: password,
      goto: 'news',
    );

    return _performPost(url, postData);
  }

  Future<bool> vote({
    @required String username,
    @required String password,
    @required int id,
    @required bool up,
  }) async {
    const String url = '$baseUrl/vote';
    final PostData postData = PostData(
      acct: username,
      pw: password,
      id: id,
      how: up ? 'up' : 'un',
    );

    return _performPost(url, postData);
  }

  Future<bool> _performPost(String url, PostData data) async {
    try {
      final Response<String> response = await _dio.post<String>(
        url,
        data: data.toJson(),
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          followRedirects: false,
          validateStatus: (int status) => status >= 200 && status < 400,
        ),
      );
      return response.statusCode == 302;
    } on DioError {
      return false;
    }
  }
}
