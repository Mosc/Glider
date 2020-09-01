import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/item.dart';

part 'item_family.freezed.dart';

@freezed
abstract class ItemFamily with _$ItemFamily {
  factory ItemFamily({
    List<Item> items,
    bool hasMore,
  }) = _ItemFamily;
}
