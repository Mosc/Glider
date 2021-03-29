import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/search_range.dart';
import 'package:glider/models/story_type.dart';

part 'search_parameters.freezed.dart';

@freezed
class SearchParameters with _$SearchParameters {
  factory SearchParameters({
    required String query,
    SearchRange? searchRange,
    DateTimeRange? customDateTimeRange,
    @Default(StoryType.bestStories) StoryType storyType,
  }) = _SearchParameters;
}
