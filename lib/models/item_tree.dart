import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:glider/models/tree_item.dart';

part 'item_tree.freezed.dart';

@freezed
class ItemTree with _$ItemTree {
  factory ItemTree({
    required Iterable<TreeItem> treeItems,
    @Default(true) bool done,
  }) = _ItemTree;
}
