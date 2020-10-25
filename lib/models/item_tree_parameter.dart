import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_tree_parameter.freezed.dart';

@freezed
abstract class ItemTreeParameter with _$ItemTreeParameter {
  factory ItemTreeParameter({
    @required int id,
    Iterable<int> ancestors,
  }) = _ItemTreeParameter;
}
