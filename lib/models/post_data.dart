import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_data.freezed.dart';
part 'post_data.g.dart';

@freezed
abstract class PostData with _$PostData {
  factory PostData({
    @required String acct,
    @required String pw,
    @JsonKey(includeIfNull: false) int id,
    @JsonKey(includeIfNull: false) String how,
    @JsonKey(includeIfNull: false) int parent,
    @JsonKey(includeIfNull: false) String text,
    @JsonKey(includeIfNull: false) String creating,
    @JsonKey(includeIfNull: false) String goto,
  }) = _PostData;

  factory PostData.fromJson(Map<String, dynamic> json) =>
      _$PostDataFromJson(json);
}
