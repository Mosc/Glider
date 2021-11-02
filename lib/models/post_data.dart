import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_data.freezed.dart';
part 'post_data.g.dart';

mixin PostDataMixin {
  Map<String, dynamic> toJson();
}

@freezed
class RegisterPostData with _$RegisterPostData, PostDataMixin {
  factory RegisterPostData({
    required String acct,
    required String pw,
    required String creating,
    required String goto,
  }) = _RegisterPostData;

  factory RegisterPostData.fromJson(Map<String, dynamic> json) =>
      _$RegisterPostDataFromJson(json);
}

@freezed
class LoginPostData with _$LoginPostData, PostDataMixin {
  factory LoginPostData({
    required String acct,
    required String pw,
    required String goto,
  }) = _LoginPostData;

  factory LoginPostData.fromJson(Map<String, dynamic> json) =>
      _$LoginPostDataFromJson(json);
}

@freezed
class FavoritePostData with _$FavoritePostData, PostDataMixin {
  factory FavoritePostData({
    required String acct,
    required String pw,
    required int id,
    String? un,
  }) = _FavoritePostData;

  factory FavoritePostData.fromJson(Map<String, dynamic> json) =>
      _$FavoritePostDataFromJson(json);
}

@freezed
class VotePostData with _$VotePostData, PostDataMixin {
  factory VotePostData({
    required String acct,
    required String pw,
    required int id,
    required String how,
  }) = _VotePostData;

  factory VotePostData.fromJson(Map<String, dynamic> json) =>
      _$VotePostDataFromJson(json);
}

@freezed
class FlagPostData with _$FlagPostData, PostDataMixin {
  factory FlagPostData({
    required String acct,
    required String pw,
    required int id,
    String? un,
  }) = _FlagPostData;

  factory FlagPostData.fromJson(Map<String, dynamic> json) =>
      _$FlagPostDataFromJson(json);
}

@freezed
class CommentPostData with _$CommentPostData, PostDataMixin {
  factory CommentPostData({
    required String acct,
    required String pw,
    required int parent,
    required String text,
  }) = _CommentPostData;

  factory CommentPostData.fromJson(Map<String, dynamic> json) =>
      _$CommentPostDataFromJson(json);
}

@freezed
class EditPostData with _$EditPostData, PostDataMixin {
  factory EditPostData({
    required String hmac,
    required int id,
    String? title,
    String? text,
  }) = _EditPostData;

  factory EditPostData.fromJson(Map<String, dynamic> json) =>
      _$EditPostDataFromJson(json);
}

@freezed
class DeletePostData with _$DeletePostData, PostDataMixin {
  factory DeletePostData({
    required String hmac,
    required int id,
    required String d,
  }) = _DeletePostData;

  factory DeletePostData.fromJson(Map<String, dynamic> json) =>
      _$DeletePostDataFromJson(json);
}

@freezed
class SubmitPostData with _$SubmitPostData, PostDataMixin {
  factory SubmitPostData({
    required String fnid,
    required String fnop,
    required String title,
    String? url,
    String? text,
  }) = _SubmitPostData;

  factory SubmitPostData.fromJson(Map<String, dynamic> json) =>
      _$SubmitPostDataFromJson(json);
}

@freezed
class FormPostData with _$FormPostData, PostDataMixin {
  factory FormPostData({
    required String acct,
    required String pw,
    int? id,
  }) = _FormPostData;

  factory FormPostData.fromJson(Map<String, dynamic> json) =>
      _$FormPostDataFromJson(json);
}
