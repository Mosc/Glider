import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/item.dart';

part 'item_tree.freezed.dart';

@freezed
abstract class ItemTree with _$ItemTree {
  factory ItemTree({
    Iterable<Item> items,
    bool hasMore,
  }) = _ItemTree;
}
