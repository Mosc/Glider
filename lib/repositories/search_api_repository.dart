import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glider/models/search_order.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/models/search_range.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/utils/service_exception.dart';

class SearchApiRepository {
  const SearchApiRepository(this._dio);

  static const String authority = 'hn.algolia.com';
  static const String basePath = 'api/v1';

  final Dio _dio;

  Future<Iterable<int>> searchItemIds(SearchParameters searchParameters) async {
    return _searchIds(
      searchParameters,
      tags: searchParameters.when(
        stories: (_, __, ___, ____, _____) => '(story,poll)',
        item: (_, __, ___, ____, int parentStoryId, _____) =>
            'story_$parentStoryId',
        favorites: (_, __, ___, ____, Iterable<int> ids, _____) =>
            '(story,poll),(${ids.map((int id) => 'story_$id').join(',')})',
      ),
    );
  }

  Future<Iterable<int>> _searchIds(SearchParameters searchParameters,
      {String? tags}) async {
    final DateTimeRange? dateTimeRange = searchParameters.range
        ?.dateTimeRange(searchParameters.customDateTimeRange);
    final Uri uri = Uri.https(
      authority,
      '$basePath/${searchParameters.order.apiPath}',
      <String, String>{
        if (searchParameters.query.isNotEmpty) 'query': searchParameters.query,
        if (tags != null) 'tags': tags,
        if (dateTimeRange != null)
          'numericFilters':
              'created_at_i>=${dateTimeRange.start.secondsSinceEpoch},'
                  'created_at_i<${dateTimeRange.end.secondsSinceEpoch}',
        'attributesToRetrieve': '',
        'attributesToHighlight': '',
        if (searchParameters.maxResults != null)
          'hitsPerPage': searchParameters.maxResults!.toString(),
        'typoTolerance': 'false',
        'analytics': 'false',
      },
    );

    try {
      final Response<Map<String, dynamic>> response =
          await _dio.getUri<Map<String, dynamic>>(uri);
      final List<dynamic> hits = response.data?['hits'] as List<dynamic>;
      return hits.map((dynamic hit) {
        final Map<String, dynamic> hitMap = hit as Map<String, dynamic>;
        final String objectId = hitMap['objectID'] as String;
        return int.parse(objectId);
      }).toList();
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
