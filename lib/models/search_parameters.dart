import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/search_order.dart';
import 'package:glider/models/search_range.dart';

part 'search_parameters.freezed.dart';

@freezed
class SearchParameters with _$SearchParameters {
  factory SearchParameters.stories({
    String? query,
    SearchRange? range,
    DateTimeRange? customDateTimeRange,
    @Default(SearchOrder.byRelevance) SearchOrder order,
  }) = _StoriesSearchParameters;

  factory SearchParameters.item({
    String? query,
    SearchRange? range,
    DateTimeRange? customDateTimeRange,
    @Default(SearchOrder.byRelevance) SearchOrder order,
    required int parentStoryId,
  }) = _ItemSearchParameters;

  factory SearchParameters.favorites({
    String? query,
    SearchRange? range,
    DateTimeRange? customDateTimeRange,
    @Default(SearchOrder.byRelevance) SearchOrder order,
    required Iterable<int> favoriteIds,
  }) = _FavoritesSearchParameters;

  factory SearchParameters.replies({
    String? query,
    SearchRange? range,
    DateTimeRange? customDateTimeRange,
    @Default(SearchOrder.byRelevance) SearchOrder order,
    required Iterable<int> parentIds,
  }) = _RepliesSearchParameters;
}
