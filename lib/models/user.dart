import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  factory User({
    String id,
    int delay,
    int created,
    int karma,
    String about,
    Iterable<int> submitted,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @late
  String get createdDate => DateFormat.yMMMMd()
      .format(DateTime.fromMillisecondsSinceEpoch(created * 1000));
}
