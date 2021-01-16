import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/search_range.dart';
import 'package:glider/models/story_type.dart';

part 'search_parameters.freezed.dart';

@freezed
abstract class SearchParameters with _$SearchParameters {
  factory SearchParameters({
    String query,
    SearchRange searchRange,
    @Default(StoryType.bestStories) StoryType storyType,
  }) = _SearchParameters;
}
