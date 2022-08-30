import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:glider/models/search_order.dart';
import 'package:glider/models/search_parameters.dart';
import 'package:glider/models/search_range.dart';
import 'package:glider/models/search_result.dart';
import 'package:glider/utils/date_time_extension.dart';
import 'package:glider/utils/service_exception.dart';

class SearchApiRepository {
  const SearchApiRepository(this._dio);

  static const String authority = 'hn.algolia.com';
  static const String basePath = 'api/v1';

  final Dio _dio;

  Future<Iterable<int>> searchItemIds(SearchParameters searchParameters) async {
    final SearchResult searchResult = await searchItems(searchParameters);
    return searchResult.hits.map((SearchResultHit hit) => int.parse(hit.id));
  }

  Future<SearchResult> searchItems(SearchParameters searchParameters) async {
    final DateTimeRange? dateTimeRange = searchParameters.range
        ?.dateTimeRange(searchParameters.customDateTimeRange);
    final Iterable<String> numericFilters = <String>[
      if (dateTimeRange != null) ...<String>[
        'created_at_i>=${dateTimeRange.start.secondsSinceEpoch}',
        'created_at_i<${dateTimeRange.end.secondsSinceEpoch}',
      ],
    ];
    final bool skipSearch = searchParameters.maybeWhen(
      favorites: (_, __, ___, ____, Iterable<int> favoriteIds) =>
          favoriteIds.isEmpty,
      replies: (_, __, ___, ____, Iterable<int> parentIds) => parentIds.isEmpty,
      orElse: () => false,
    );

    if (skipSearch) {
      return SearchResult();
    }

    return _search(
      order: searchParameters.order,
      query: searchParameters.query,
      tags: searchParameters.whenOrNull(
        stories: (_, __, ___, ____) => <String>['(story,poll)'],
        item: (_, __, ___, ____, int parentStoryId) =>
            <String>['story_$parentStoryId'],
        favorites: (_, __, ___, ____, Iterable<int> favoriteIds) => <String>[
          '(story,poll)',
          '(${favoriteIds.map((int id) => 'story_$id').join(',')})',
        ],
      ),
      numericFilters: searchParameters.maybeWhen(
        replies: (_, __, ___, ____, Iterable<int> parentIds) => <String>[
          ...numericFilters,
          // Limit parent IDs to prevent HTTP status 414 URI Too Long.
          '(${parentIds.take(300).map((int id) => 'parent_id=$id').join(',')})',
        ],
        orElse: () => numericFilters,
      ),
      attributesToRetrieve: searchParameters.whenOrNull(
        replies: (_, __, ___, ____, _____) => <String>['parent_id'],
      ),
    );
  }

  Future<SearchResult> _search({
    SearchOrder order = SearchOrder.byRelevance,
    String? query,
    Iterable<String>? tags,
    Iterable<String>? numericFilters,
    Iterable<String>? attributesToRetrieve,
  }) async {
    final Uri uri = Uri.https(
      authority,
      '$basePath/${order.apiPath}',
      <String, String>{
        if (query?.isNotEmpty ?? false) 'query': query!,
        if (tags?.isNotEmpty ?? false) 'tags': tags!.join(','),
        if (numericFilters?.isNotEmpty ?? false)
          'numericFilters': numericFilters!.join(','),
        'attributesToRetrieve': attributesToRetrieve?.join(',') ?? '',
        'attributesToHighlight': '',
        'hitsPerPage': 1000.toString(),
        'typoTolerance': false.toString(),
        'analytics': false.toString(),
      },
    );

    try {
      final Response<Map<String, dynamic>> response =
          await _dio.getUri<Map<String, dynamic>>(uri);

      if (response.data == null) {
        throw ServiceException();
      }

      return SearchResult.fromJson(response.data!);
    } on DioError catch (e) {
      throw ServiceException(e.message);
    }
  }
}
