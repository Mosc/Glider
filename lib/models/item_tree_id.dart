import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_tree_id.freezed.dart';

@freezed
class ItemTreeId with _$ItemTreeId {
  factory ItemTreeId({
    required int id,
    @Default(<int>[]) Iterable<int> ancestorIds,
    @Default(<int>[]) Iterable<int> descendantIds,
  }) = _ItemTreeId;
}
