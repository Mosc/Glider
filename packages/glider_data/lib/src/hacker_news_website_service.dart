import 'package:collection/collection.dart';
import 'package:compute/compute.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class HackerNewsWebsiteService {
  const HackerNewsWebsiteService(this._client);

  static const String authority = 'news.ycombinator.com';

  final http.Client _client;

  Future<Iterable<int>> getUpvoted({
    required String username,
    required String userCookie,
  }) async {
    return [
      ...await _getUpvotedType(
        username: username,
        userCookie: userCookie,
        comments: false,
      ),
      ...await _getUpvotedType(
        username: username,
        userCookie: userCookie,
        comments: true,
      ),
    ].sorted((a, b) => b.compareTo(a));
  }

  Future<Iterable<int>> _getUpvotedType({
    required String username,
    required String userCookie,
    required bool comments,
    int page = 1,
  }) async {
    final uri = Uri.https(
      authority,
      'upvoted',
      <String, String>{
        'id': username,
        if (page > 1) 'p': page.toString(),
        if (comments) 'comments': 't',
      },
    );
    final response = await _performGet(uri, userCookie: userCookie);
    final document = await compute(html_parser.parse, response.body);
    return document.getThingIds(
      onMore: () => _getUpvotedType(
        username: username,
        userCookie: userCookie,
        page: page + 1,
        comments: comments,
      ),
    );
  }

  Future<Iterable<int>> getFavorited({required String username}) async {
    return [
      ...await _getFavoritedType(
        username: username,
        comments: false,
      ),
      ...await _getFavoritedType(
        username: username,
        comments: true,
      ),
    ].sorted((a, b) => b.compareTo(a));
  }

  Future<Iterable<int>> _getFavoritedType({
    required String username,
    required bool comments,
    int page = 1,
  }) async {
    final uri = Uri.https(
      authority,
      'favorites',
      <String, String>{
        'id': username,
        if (page > 1) 'p': page.toString(),
        if (comments) 'comments': 't',
      },
    );
    final response = await _performGet(uri);
    final document = await compute(html_parser.parse, response.body);
    return document.getThingIds(
      onMore: () => _getFavoritedType(
        username: username,
        page: page + 1,
        comments: comments,
      ),
    );
  }

  Future<Iterable<int>> getFlagged({
    required String username,
    required String userCookie,
  }) async {
    return [
      ...await _getFlaggedType(
        username: username,
        userCookie: userCookie,
        comments: false,
      ),
      ...await _getFlaggedType(
        username: username,
        userCookie: userCookie,
        comments: true,
      ),
    ].sorted((a, b) => b.compareTo(a));
  }

  Future<Iterable<int>> _getFlaggedType({
    required String username,
    required String userCookie,
    required bool comments,
    int page = 1,
  }) async {
    final uri = Uri.https(
      authority,
      'flagged',
      <String, String>{
        'id': username,
        if (page > 1) 'p': page.toString(),
        if (comments) 'kind': 'comment',
      },
    );
    final response = await _performGet(uri, userCookie: userCookie);
    final document = await compute(html_parser.parse, response.body);
    return document.getThingIds(
      onMore: () => _getFlaggedType(
        username: username,
        userCookie: userCookie,
        page: page + 1,
        comments: comments,
      ),
    );
  }

  Future<void> upvote({
    required int id,
    required bool upvote,
    required String userCookie,
  }) async {
    final auth = await _getItemAuthValue(id: id, userCookie: userCookie);
    final endpoint = Uri.https(authority, 'vote');
    final body = <String, String>{
      'id': id.toString(),
      'how': upvote ? 'up' : 'un',
      'auth': auth!,
    };
    await _performPost(endpoint, body: body, userCookie: userCookie);
  }

  Future<void> downvote({
    required int id,
    required bool downvote,
    required String userCookie,
  }) async {
    final auth = await _getItemAuthValue(id: id, userCookie: userCookie);
    final endpoint = Uri.https(authority, 'vote');
    final body = <String, String>{
      'id': id.toString(),
      'how': downvote ? 'down' : 'un',
      'auth': auth!,
    };
    await _performPost(endpoint, body: body, userCookie: userCookie);
  }

  Future<void> favorite({
    required int id,
    required bool favorite,
    required String userCookie,
  }) async {
    final auth = await _getItemAuthValue(id: id, userCookie: userCookie);
    final endpoint = Uri.https(authority, 'fave');
    final body = <String, String>{
      'id': id.toString(),
      if (!favorite) 'un': 't',
      'auth': auth!,
    };
    await _performPost(endpoint, body: body, userCookie: userCookie);
  }

  Future<void> flag({
    required int id,
    required bool flag,
    required String userCookie,
  }) async {
    final auth = await _getItemAuthValue(id: id, userCookie: userCookie);
    final endpoint = Uri.https(authority, 'flag');
    final body = <String, String>{
      'id': id.toString(),
      if (!flag) 'un': 't',
      'auth': auth!,
    };
    await _performPost(endpoint, body: body, userCookie: userCookie);
  }

  Future<void> edit({
    required int id,
    String? title,
    String? text,
    // ignore: always_put_required_named_parameters_first
    required String userCookie,
  }) async {
    final hmac = await _getItemHmacValue(id: id, userCookie: userCookie);
    final endpoint = Uri.https(authority, 'xedit');
    final body = <String, String>{
      'id': id.toString(),
      if (title != null) 'title': title,
      if (text != null) 'text': text,
      'hmac': hmac!,
    };
    await _performPost(endpoint, body: body, userCookie: userCookie);
  }

  Future<void> delete({
    required int id,
    required String userCookie,
  }) async {
    final hmac = await _getItemHmacValue(id: id, userCookie: userCookie);
    final endpoint = Uri.https(authority, 'xdelete');
    final body = <String, String>{
      'id': id.toString(),
      'd': 'Yes',
      'hmac': hmac!,
    };
    await _performPost(endpoint, body: body, userCookie: userCookie);
  }

  Future<void> reply({
    required int parentId,
    required String text,
    required String userCookie,
  }) async {
    final hmac = await _getItemHmacValue(id: parentId, userCookie: userCookie);
    final endpoint = Uri.https(authority, 'comment');
    final body = <String, String>{
      'parent': parentId.toString(),
      'text': text,
      'hmac': hmac!,
      'goto': 'item?id=$parentId',
    };
    await _performPost(endpoint, body: body, userCookie: userCookie);
  }

  Future<void> submit({
    required String title,
    String? url,
    String? text,
    // ignore: always_put_required_named_parameters_first
    required String userCookie,
  }) async {
    final (fnid, fnop) = await _getFnidFnopValues(userCookie: userCookie);
    final endpoint = Uri.https(authority, 'r');
    final body = <String, String>{
      'title': title,
      if (url != null) 'url': url,
      if (text != null) 'text': text,
      'fnid': fnid!,
      'fnop': fnop!,
    };
    await _performPost(endpoint, body: body, userCookie: userCookie);
  }

  Future<String?> _getItemAuthValue({
    required int id,
    required String userCookie,
  }) async {
    final endpoint = _getItemUrl(id);
    final response = await _performGet(endpoint, userCookie: userCookie);
    final voteHref = await compute(
      (body) =>
          html_parser.parse(body).getElementById('up_$id')?.attributes['href'],
      response.body,
    );

    if (voteHref == null) {
      return null;
    }

    final voteUrl = Uri.parse(voteHref);
    return voteUrl.queryParameters['auth'];
  }

  Future<String?> _getItemHmacValue({
    required int id,
    required String userCookie,
  }) async {
    final endpoint = _getItemUrl(id);
    final response = await _performGet(endpoint, userCookie: userCookie);
    return compute(
      (body) => html_parser
          .parse(body)
          .hiddenFormAttributes
          ?.getAttributeValue('hmac'),
      response.body,
    );
  }

  Future<(String? fnid, String? fnop)> _getFnidFnopValues({
    required String userCookie,
  }) async {
    final endpoint = Uri.https(authority, 'submit');
    final response = await _performGet(endpoint, userCookie: userCookie);
    return compute(
      (body) {
        final attributes = html_parser.parse(body).hiddenFormAttributes;
        return (
          attributes?.getAttributeValue('fnid'),
          attributes?.getAttributeValue('fnop'),
        );
      },
      response.body,
    );
  }

  Uri _getItemUrl(int id) =>
      Uri.https(authority, 'item', <String, dynamic>{'id': id.toString()});

  Future<http.Response> _performGet(
    Uri endpoint, {
    String? userCookie,
  }) async =>
      _client.get(
        endpoint,
        headers: _getHeaders(userCookie: userCookie),
      );

  Future<http.Response> _performPost(
    Uri endpoint, {
    Object? body,
    String? userCookie,
  }) async =>
      _client.post(
        endpoint,
        body: body,
        headers: _getHeaders(userCookie: userCookie),
      );

  Map<String, String> _getHeaders({String? userCookie}) => <String, String>{
        if (userCookie != null) 'cookie': 'user=$userCookie',
      };
}

extension on html_dom.Document {
  Iterable<Map<Object, String>>? get hiddenFormAttributes =>
      getElementsByTagName('form')
          .firstOrNull
          ?.querySelectorAll("input[type='hidden']")
          .map((element) => element.attributes);

  Future<Iterable<int>> getThingIds({
    required Future<Iterable<int>> Function() onMore,
  }) async =>
      <int>[
        ...querySelectorAll('.athing').map((thing) => int.parse(thing.id)),
        if (querySelector('.morelink') != null) ...await onMore(),
      ];
}

extension on Iterable<Map<Object, String>> {
  String? getAttributeValue(String name) => firstWhereOrNull(
        (attributes) => attributes['name'] == name,
      )?['value'];
}
