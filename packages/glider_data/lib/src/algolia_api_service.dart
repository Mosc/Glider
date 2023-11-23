import 'dart:convert';

import 'package:compute/compute.dart';
import 'package:glider_data/src/dtos/algolia_search_dto.dart';
import 'package:http/http.dart' as http;

class AlgoliaApiService {
  const AlgoliaApiService(this._client);

  final http.Client _client;

  static const authority = 'hn.algolia.com';
  static const _searchPath = '/api/v1/search';
  static const _searchByDatePath = '/api/v1/search_by_date';

  Map<String, String> _getCommonQueryParameters({int hits = 1000}) => {
        'hitsPerPage': hits.toString(),
        // Specify non-existent attribute to avoid returning highlight results.
        'attributesToHighlight': '_',
        'typoTolerance': false.toString(),
        'analytics': false.toString(),
      };

  Future<AlgoliaSearchDto> searchStories({
    String? query,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final numericFilters = [
      if (startDate != null)
        'created_at_i>=${startDate.millisecondsSinceEpoch ~/ 1000}',
      if (endDate != null)
        'created_at_i<${endDate.millisecondsSinceEpoch ~/ 1000}',
    ];
    final queryParameters = <String, String>{
      if (query != null && query.isNotEmpty) 'query': query,
      'tags': '(story,poll)',
      if (numericFilters.isNotEmpty) 'numericFilters': numericFilters.join(','),
      'attributesToRetrieve':
          'title,url,author,points,story_text,num_comments,created_at_i',
      ..._getCommonQueryParameters(),
    };
    final response = await _client.get(
      Uri.https(authority, _searchPath, queryParameters),
    );
    return compute(
      (body) {
        final map = jsonDecode(body) as Map<String, dynamic>;
        return AlgoliaSearchDto.fromJson(map);
      },
      response.body,
    );
  }

  Future<AlgoliaSearchDto> searchStoryItems(int id, {String? query}) async {
    final queryParameters = <String, String>{
      if (query != null && query.isNotEmpty) 'query': query,
      'tags': 'story_$id',
      'attributesToRetrieve':
          'title,url,author,points,story_text,num_comments,created_at_i,'
              'comment_text,parent_id',
      ..._getCommonQueryParameters(),
    };
    final response = await _client.get(
      Uri.https(authority, _searchPath, queryParameters),
    );
    return compute(
      (body) {
        final map = jsonDecode(body) as Map<String, dynamic>;
        return AlgoliaSearchDto.fromJson(map);
      },
      response.body,
    );
  }

  Future<AlgoliaSearchDto> getSimilarStories(
    int id, {
    required String url,
  }) async {
    final queryParameters = <String, String>{
      'query': url,
      'tags': '(story,poll)',
      'attributesToRetrieve':
          'title,url,author,points,story_text,num_comments,created_at_i,'
              'comment_text,parent_id',
      'restrictSearchableAttributes': 'url',
      'filters': 'NOT objectID:$id',
      'numericFilters': 'num_comments>0',
      ..._getCommonQueryParameters(hits: 3),
    };
    final response = await _client.get(
      Uri.https(authority, _searchPath, queryParameters),
    );
    return compute(
      (body) {
        final map = jsonDecode(body) as Map<String, dynamic>;
        return AlgoliaSearchDto.fromJson(map);
      },
      response.body,
    );
  }

  Future<AlgoliaSearchDto> searchUserItems(
    String username, {
    String? query,
  }) async {
    final queryParameters = <String, String>{
      if (query != null && query.isNotEmpty) 'query': query,
      'tags': 'author_$username',
      'attributesToRetrieve':
          'title,url,author,points,story_text,num_comments,created_at_i,'
              'comment_text,parent_id',
      ..._getCommonQueryParameters(),
    };
    final response = await _client.get(
      Uri.https(authority, _searchPath, queryParameters),
    );
    return compute(
      (body) {
        final map = jsonDecode(body) as Map<String, dynamic>;
        return AlgoliaSearchDto.fromJson(map);
      },
      response.body,
    );
  }

  Future<AlgoliaSearchDto> getUserReplies(Iterable<int> ids) async {
    final queryParameters = <String, String>{
      'attributesToRetrieve':
          'title,url,author,points,story_text,num_comments,created_at_i,'
              'comment_text,parent_id',
      'numericFilters': '(${ids.map((id) => 'parent_id=$id').join(',')})',
      ..._getCommonQueryParameters(),
    };
    final response = await _client.get(
      Uri.https(authority, _searchByDatePath, queryParameters),
    );
    return compute(
      (body) {
        final map = jsonDecode(body) as Map<String, dynamic>;
        return AlgoliaSearchDto.fromJson(map);
      },
      response.body,
    );
  }
}
