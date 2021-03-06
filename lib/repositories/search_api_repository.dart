import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/models/story_type.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/utils/service_exception.dart';

class SearchApiRepository {
  const SearchApiRepository(this._dio);

  static const String authority = 'hn.algolia.com';
  static const String basePath = 'api/v1';

  final Dio _dio;

  Future<Iterable<int>> searchStoryIds(
      SearchParameters searchParameters) async {
    final DateTimeRange dateTimeRange = searchParameters.dateTimeRange;
    final Uri uri = Uri.https(
      authority,
      '$basePath/${searchParameters.storyType.searchApiPath}',
      <String, String>{
        'query': searchParameters.query,
        'tags': '(story,poll)',
        if (dateTimeRange != null)
          'numericFilters':
              'created_at_i>=${dateTimeRange.start.secondsSinceEpoch},'
                  'created_at_i<${dateTimeRange.end.secondsSinceEpoch}',
      },
    );

    try {
      final Response<Map<String, dynamic>> response =
          await _dio.getUri<Map<String, dynamic>>(uri);
      return response.data['hits']
          .map<int>((dynamic hit) => int.parse(hit['objectID'] as String))
          .toList() as Iterable<int>;
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
