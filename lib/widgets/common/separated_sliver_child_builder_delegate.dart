import 'dart:math';

import 'package:flutter/widgets.dart';

class SeparatedSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  SeparatedSliverChildBuilderDelegate({
    @required IndexedWidgetBuilder itemBuilder,
    @required IndexedWidgetBuilder separatorBuilder,
    ChildIndexGetter findChildIndexCallback,
    int childCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    int semanticIndexOffset = 0,
  }) : super(
          (BuildContext context, int index) {
            final int itemIndex = index ~/ 2;
            return index.isEven
                ? itemBuilder(context, itemIndex)
                : separatorBuilder(context, itemIndex);
          },
          findChildIndexCallback: findChildIndexCallback,
          childCount: childCount != null ? max(0, childCount * 2 - 1) : null,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: (_, int index) =>
              index.isEven ? index ~/ 2 : null,
          semanticIndexOffset: semanticIndexOffset,
        );
}
