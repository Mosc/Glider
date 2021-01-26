import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:glider/models/post_data.dart';
import 'package:glider/utils/html_util.dart';
import 'package:glider/utils/service_exception.dart';

class WebsiteRepository {
  const WebsiteRepository(this._dio);

  static const String authority = 'news.ycombinator.com';

  final Dio _dio;

  Future<bool> register({
    @required String username,
    @required String password,
  }) async {
    final Uri uri = Uri.https(authority, 'login');
    final PostData data = RegisterPostData(
      acct: username,
      pw: password,
      creating: 't',
      goto: 'news',
    );

    return _performDefaultPost(uri, data);
  }

  Future<bool> login({
    @required String username,
    @required String password,
  }) async {
    final Uri uri = Uri.https(authority, 'login');
    final PostData data = LoginPostData(
      acct: username,
      pw: password,
      goto: 'news',
    );

    return _performDefaultPost(uri, data);
  }

  Future<bool> favorite({
    @required String username,
    @required String password,
    @required int id,
    @required bool favorite,
  }) async {
    final Uri uri = Uri.https(authority, 'fave');
    final PostData data = FavoritePostData(
      acct: username,
      pw: password,
      id: id,
      un: favorite ? null : 't',
    );

    return _performDefaultPost(uri, data);
  }

  Future<bool> vote({
    @required String username,
    @required String password,
    @required int id,
    @required bool up,
  }) async {
    final Uri uri = Uri.https(authority, 'vote');
    final PostData data = VotePostData(
      acct: username,
      pw: password,
      id: id,
      how: up ? 'up' : 'un',
    );

    return _performDefaultPost(uri, data);
  }

  Future<bool> comment({
    @required String username,
    @required String password,
    @required int parentId,
    @required String text,
  }) async {
    final Uri uri = Uri.https(authority, 'comment');
    final PostData data = CommentPostData(
      acct: username,
      pw: password,
      parent: parentId,
      text: text,
    );

    return _performDefaultPost(
      uri,
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
    final Uri formUri = Uri.https(authority, 'submitlink');
    final PostData formData = SubmitFormPostData(
      acct: username,
      pw: password,
    );

    final Response<List<int>> response = await _performPost<List<int>>(
      formUri,
      formData,
      responseType: ResponseType.bytes,
      validateStatus: (int status) => status == HttpStatus.ok,
    );
    final Map<String, String> formValues =
        HtmlUtil.getHiddenFormValues(response.data);

    if (formValues == null || formValues.isEmpty) {
      return false;
    }

    final Uri uri = Uri.https(authority, 'r');
    final PostData data = SubmitPostData(
      fnid: formValues['fnid'],
      fnop: formValues['fnop'],
      title: title,
      url: url,
      text: text,
    );
    final String cookie = response.headers.value('set-cookie');

    return _performDefaultPost(
      uri,
      data,
      cookie: cookie,
      validateLocation: (String location) => location == '/newest',
    );
  }

  Future<bool> _performDefaultPost(
    Uri uri,
    PostData data, {
    String cookie,
    bool Function(String) validateLocation,
  }) async {
    try {
      final Response<void> response = await _performPost<void>(
        uri,
        data,
        cookie: cookie,
        validateStatus: (int status) => status == HttpStatus.found,
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
    Uri uri,
    PostData data, {
    String cookie,
    ResponseType responseType,
    bool Function(int) validateStatus,
  }) async {
    try {
      return _dio.postUri<T>(
        uri,
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
