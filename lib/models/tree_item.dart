import 'package:freezed_annotation/freezed_annotation.dart';

part 'tree_item.freezed.dart';

@freezed
class TreeItem with _$TreeItem {
  factory TreeItem({
    required int id,
    @Default(<TreeItem>[]) Iterable<TreeItem> childTreeItems,
    @Default(<int>[]) Iterable<int> descendantIds,
    @Default(<int>[]) Iterable<int> ancestorIds,
  }) = _TreeItem;
}
