import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'descendant_id.freezed.dart';

@freezed
class DescendantId with _$DescendantId {
  factory DescendantId({
    required int id,
    required Iterable<int> ancestors,
  }) = _DescendantId;
}
