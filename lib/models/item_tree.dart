import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/descendant_id.dart';

part 'item_tree.freezed.dart';

@freezed
class ItemTree with _$ItemTree {
  factory ItemTree({
    required Iterable<DescendantId> descendantIds,
    @Default(true) bool done,
  }) = _ItemTree;
}
