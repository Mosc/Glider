import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/search_order.dart';
import 'package:glider/models/search_range.dart';

part 'search_parameters.freezed.dart';

@freezed
class SearchParameters with _$SearchParameters {
  factory SearchParameters({
    required String query,
    SearchRange? range,
    DateTimeRange? customDateTimeRange,
    @Default(SearchOrder.byRelevance) SearchOrder order,
    int? parentStoryId,
    int? maxResults,
  }) = _SearchParameters;
}
