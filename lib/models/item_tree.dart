import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/item.dart';

part 'item_tree.freezed.dart';

@freezed
class ItemTree with _$ItemTree {
  factory ItemTree({
    required Iterable<Item> items,
    required bool done,
  }) = _ItemTree;
}
