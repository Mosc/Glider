import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

@Freezed(toJson: false)
class SearchResult with _$SearchResult {
  factory SearchResult({
    @Default(<SearchResultHit>[]) Iterable<SearchResultHit> hits,
  }) = _SearchResult;

  SearchResult._();

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}

@Freezed(toJson: false)
class SearchResultHit with _$SearchResultHit {
  factory SearchResultHit({
    @JsonKey(name: 'objectID') required String id,
    @JsonKey(name: 'parent_id') int? parentId,
  }) = _SearchResultHit;

  SearchResultHit._();

  factory SearchResultHit.fromJson(Map<String, dynamic> json) =>
      _$SearchResultHitFromJson(json);
}
