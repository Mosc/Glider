import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_data.freezed.dart';
part 'post_data.g.dart';

mixin PostDataMixin {
  Map<String, dynamic> toJson();
}

@Freezed(fromJson: false, toJson: true)
class RegisterPostData with _$RegisterPostData, PostDataMixin {
  factory RegisterPostData({
    required String acct,
    required String pw,
    required String creating,
    required String goto,
  }) = _RegisterPostData;
}

@Freezed(fromJson: false, toJson: true)
class LoginPostData with _$LoginPostData, PostDataMixin {
  factory LoginPostData({
    required String acct,
    required String pw,
    required String goto,
  }) = _LoginPostData;
}

@Freezed(fromJson: false, toJson: true)
class FavoritePostData with _$FavoritePostData, PostDataMixin {
  factory FavoritePostData({
    required String acct,
    required String pw,
    required int id,
    String? un,
  }) = _FavoritePostData;
}

@Freezed(fromJson: false, toJson: true)
class VotePostData with _$VotePostData, PostDataMixin {
  factory VotePostData({
    required String acct,
    required String pw,
    required int id,
    required String how,
  }) = _VotePostData;
}

@Freezed(fromJson: false, toJson: true)
class FlagPostData with _$FlagPostData, PostDataMixin {
  factory FlagPostData({
    required String acct,
    required String pw,
    required int id,
    String? un,
  }) = _FlagPostData;
}

@Freezed(fromJson: false, toJson: true)
class CommentPostData with _$CommentPostData, PostDataMixin {
  factory CommentPostData({
    required String acct,
    required String pw,
    required int parent,
    required String text,
  }) = _CommentPostData;
}

@Freezed(fromJson: false, toJson: true)
class EditPostData with _$EditPostData, PostDataMixin {
  factory EditPostData({
    required String hmac,
    required int id,
    String? title,
    String? text,
  }) = _EditPostData;
}

@Freezed(fromJson: false, toJson: true)
class DeletePostData with _$DeletePostData, PostDataMixin {
  factory DeletePostData({
    required String hmac,
    required int id,
    required String d,
  }) = _DeletePostData;
}

@Freezed(fromJson: false, toJson: true)
class SubmitPostData with _$SubmitPostData, PostDataMixin {
  factory SubmitPostData({
    required String fnid,
    required String fnop,
    required String title,
    String? url,
    String? text,
  }) = _SubmitPostData;
}

@Freezed(fromJson: false, toJson: true)
class FormPostData with _$FormPostData, PostDataMixin {
  factory FormPostData({
    required String acct,
    required String pw,
    int? id,
  }) = _FormPostData;
}
