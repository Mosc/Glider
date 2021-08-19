import 'dart:io';

import 'package:dio/dio.dart';
import 'package:glider/models/post_data.dart';
import 'package:glider/utils/html_util.dart';
import 'package:glider/utils/service_exception.dart';
import 'package:html/dom.dart' as dom;

class WebsiteRepository {
  const WebsiteRepository(this._dio);

  static const String authority = 'news.ycombinator.com';

  static const String _itemSelector = '.athing';
  static const String _moreSelector = '.morelink';

  final Dio _dio;

  Future<bool> register({
    required String username,
    required String password,
  }) async {
    final Uri uri = Uri.https(authority, 'login');
    final PostDataMixin data = RegisterPostData(
      acct: username,
      pw: password,
      creating: 't',
      goto: 'news',
    );

    return _performDefaultPost(uri, data);
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final Uri uri = Uri.https(authority, 'login');
    final PostDataMixin data = LoginPostData(
      acct: username,
      pw: password,
      goto: 'news',
    );

    return _performDefaultPost(uri, data);
  }

  Future<bool> favorite({
    required String username,
    required String password,
    required int id,
    required bool favorite,
  }) async {
    final Uri uri = Uri.https(authority, 'fave');
    final PostDataMixin data = FavoritePostData(
      acct: username,
      pw: password,
      id: id,
      un: favorite ? null : 't',
    );

    return _performDefaultPost(uri, data);
  }

  Future<bool> vote({
    required String username,
    required String password,
    required int id,
    required bool upvote,
  }) async {
    final Uri uri = Uri.https(authority, 'vote');
    final PostDataMixin data = VotePostData(
      acct: username,
      pw: password,
      id: id,
      how: upvote ? 'up' : 'un',
    );

    return _performDefaultPost(uri, data);
  }

  Future<bool> comment({
    required String username,
    required String password,
    required int parentId,
    required String text,
  }) async {
    final Uri uri = Uri.https(authority, 'comment');
    final PostDataMixin data = CommentPostData(
      acct: username,
      pw: password,
      parent: parentId,
      text: text,
    );

    return _performDefaultPost(
      uri,
      data,
      validateLocation: (String? location) => location == '/',
    );
  }

  Future<bool> submit({
    required String username,
    required String password,
    required String title,
    String? url,
    String? text,
  }) async {
    final Response<List<int>> formResponse =
        await _getSubmitFormResponse(username: username, password: password);
    final Map<String, String>? formValues =
        HtmlUtil.getHiddenFormValues(formResponse.data);

    if (formValues == null || formValues.isEmpty) {
      return false;
    }

    final String? cookie =
        formResponse.headers.value(HttpHeaders.setCookieHeader);

    final Uri uri = Uri.https(authority, 'r');
    final PostDataMixin data = SubmitPostData(
      fnid: formValues['fnid']!,
      fnop: formValues['fnop']!,
      title: title,
      url: url,
      text: text,
    );

    return _performDefaultPost(
      uri,
      data,
      cookie: cookie,
      validateLocation: (String? location) => location == '/newest',
    );
  }

  Future<Iterable<int>> getFavorited({required String username}) async {
    return <int>[
      ...await _getFavorited(
        username: username,
        comments: false,
      ),
      ...await _getFavorited(
        username: username,
        comments: true,
      ),
    ];
  }

  Future<Iterable<int>> getUpvoted(
      {required String username, required String password}) async {
    // We're not interested in the submit form specifically, but it's a rather
    // small page that returns the cookie we need for the next call.
    final Response<void> formResponse =
        await _getSubmitFormResponse(username: username, password: password);
    final String? cookie =
        formResponse.headers.value(HttpHeaders.setCookieHeader);

    return <int>[
      ...await _getUpvoted(
        username: username,
        password: password,
        comments: false,
        cookie: cookie,
      ),
      ...await _getUpvoted(
        username: username,
        password: password,
        comments: true,
        cookie: cookie,
      ),
    ];
  }

  Future<Iterable<int>> _getFavorited({
    required String username,
    int page = 1,
    required bool comments,
  }) async {
    final Uri uri = Uri.https(
      authority,
      'favorites',
      <String, String>{
        'id': username,
        if (page > 1) 'p': page.toString(),
        if (comments) 'comments': 't',
      },
    );

    final Response<List<int>> response = await _performGet(uri);
    final dom.Element? body = HtmlUtil.getBody(response.data);
    return <int>[
      ...?HtmlUtil.getIds(body, selector: _itemSelector)?.map(int.parse),
      if (HtmlUtil.hasMatch(body, selector: _moreSelector))
        ...await _getFavorited(
          username: username,
          comments: comments,
          page: page + 1,
        ),
    ];
  }

  Future<Iterable<int>> _getUpvoted({
    required String username,
    required String password,
    int page = 1,
    required bool comments,
    String? cookie,
  }) async {
    final Uri uri = Uri.https(
      authority,
      'upvoted',
      <String, String>{
        'id': username,
        if (page > 1) 'p': page.toString(),
        if (comments) 'comments': 't',
      },
    );

    final Response<List<int>> response = await _performGet(
      uri,
      cookie: cookie,
    );
    final dom.Element? body = HtmlUtil.getBody(response.data);
    return <int>[
      ...?HtmlUtil.getIds(body, selector: _itemSelector)?.map(int.parse),
      if (HtmlUtil.hasMatch(body, selector: _moreSelector))
        ...await _getUpvoted(
          username: username,
          password: password,
          page: page + 1,
          comments: comments,
          cookie: cookie,
        ),
    ];
  }

  Future<Response<List<int>>> _getSubmitFormResponse({
    required String username,
    required String password,
  }) async {
    final Uri uri = Uri.https(authority, 'submitlink');
    final PostDataMixin data = SubmitFormPostData(
      acct: username,
      pw: password,
    );
    return _performPost(
      uri,
      data,
      responseType: ResponseType.bytes,
      validateStatus: (int? status) => status == HttpStatus.ok,
    );
  }

  Future<Response<T>> _performGet<T>(Uri uri, {String? cookie}) async {
    try {
      return await _dio.getUri<T>(
        uri,
        options: Options(
          headers: <String, dynamic>{if (cookie != null) 'cookie': cookie},
          responseType: ResponseType.bytes,
        ),
      );
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }

  Future<bool> _performDefaultPost(
    Uri uri,
    PostDataMixin data, {
    String? cookie,
    bool Function(String?)? validateLocation,
  }) async {
    try {
      final Response<void> response = await _performPost<void>(
        uri,
        data,
        cookie: cookie,
        validateStatus: (int? status) => status == HttpStatus.found,
      );

      if (validateLocation != null) {
        return validateLocation(response.headers.value('location'));
      }

      return true;
    } on ServiceException {
      return false;
    }
  }

  Future<Response<T>> _performPost<T>(
    Uri uri,
    PostDataMixin data, {
    String? cookie,
    ResponseType? responseType,
    bool Function(int?)? validateStatus,
  }) async {
    try {
      return await _dio.postUri<T>(
        uri,
        data: data.toJson(),
        options: Options(
          headers: <String, dynamic>{if (cookie != null) 'cookie': cookie},
          responseType: responseType,
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: validateStatus,
        ),
      );
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
