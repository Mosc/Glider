import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/item_tree_id.dart';

part 'item_tree.freezed.dart';

@freezed
class ItemTree with _$ItemTree {
  factory ItemTree({
    required Iterable<ItemTreeId> itemTreeIds,
    @Default(true) bool done,
  }) = _ItemTree;
}
