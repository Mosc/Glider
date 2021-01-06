import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:glider/models/post_data.dart';
import 'package:glider/utils/html_util.dart';

class WebsiteRepository {
  const WebsiteRepository(this._dio);

  static const String baseUrl = 'https://news.ycombinator.com';

  final Dio _dio;

  Future<bool> register({
    @required String username,
    @required String password,
  }) async {
    const String path = '$baseUrl/login';
    final PostData data = RegisterPostData(
      acct: username,
      pw: password,
      creating: 't',
      goto: 'news',
    );

    return _performDefaultPost(path, data);
  }

  Future<bool> login({
    @required String username,
    @required String password,
  }) async {
    const String path = '$baseUrl/login';
    final PostData data = LoginPostData(
      acct: username,
      pw: password,
      goto: 'news',
    );

    return _performDefaultPost(path, data);
  }

  Future<bool> favorite({
    @required String username,
    @required String password,
    @required int id,
    @required bool favorite,
  }) async {
    const String path = '$baseUrl/fave';
    final PostData data = FavoritePostData(
      acct: username,
      pw: password,
      id: id,
      un: favorite ? null : 't',
    );

    return _performDefaultPost(path, data);
  }

  Future<bool> vote({
    @required String username,
    @required String password,
    @required int id,
    @required bool up,
  }) async {
    const String path = '$baseUrl/vote';
    final PostData data = VotePostData(
      acct: username,
      pw: password,
      id: id,
      how: up ? 'up' : 'un',
    );

    return _performDefaultPost(path, data);
  }

  Future<bool> comment({
    @required String username,
    @required String password,
    @required int parentId,
    @required String text,
  }) async {
    const String path = '$baseUrl/comment';
    final PostData data = CommentPostData(
      acct: username,
      pw: password,
      parent: parentId,
      text: text,
    );

    return _performDefaultPost(
      path,
      data,
      validateLocation: (String location) => location == '/',
    );
  }

  Future<bool> submit({
    @required String username,
    @required String password,
    @required String title,
    String url,
    String text,
  }) async {
    const String formPath = '$baseUrl/submitlink';
    final PostData formData = SubmitFormPostData(
      acct: username,
      pw: password,
    );

    final Response<List<int>> response = await _performPost<List<int>>(
      formPath,
      formData,
      responseType: ResponseType.bytes,
      validateStatus: (int status) => status == 200,
    );
    final Map<String, String> formValues =
        HtmlUtil.getHiddenFormValues(response.data);

    if (formValues == null || formValues.isEmpty) {
      return false;
    }

    const String path = '$baseUrl/r';
    final PostData data = SubmitPostData(
      fnid: formValues['fnid'],
      fnop: formValues['fnop'],
      title: title,
      url: url,
      text: text,
    );
    final String cookie = response.headers.value('set-cookie');

    return _performDefaultPost(
      path,
      data,
      cookie: cookie,
      validateLocation: (String location) => location == '/newest',
    );
  }

  Future<bool> _performDefaultPost(
    String path,
    PostData data, {
    String cookie,
    bool Function(String) validateLocation,
  }) async {
    try {
      final Response<void> response = await _performPost<void>(
        path,
        data,
        cookie: cookie,
        validateStatus: (int status) => status == 302,
      );

      if (validateLocation != null) {
        return validateLocation(response.headers.value('location'));
      }

      return true;
    } on DioError {
      return false;
    }
  }

  Future<Response<T>> _performPost<T>(
    String path,
    PostData data, {
    String cookie,
    ResponseType responseType,
    bool Function(int) validateStatus,
  }) async {
    try {
      return _dio.post<T>(
        path,
        data: data.toJson(),
        options: Options(
          headers: <String, dynamic>{if (cookie != null) 'cookie': cookie},
          responseType: responseType,
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: validateStatus,
        ),
      );
    } on DioError {
      return null;
    }
  }
}
