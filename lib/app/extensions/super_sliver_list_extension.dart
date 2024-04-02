import 'package:flutter/material.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

extension SuperSliverListExtension on SuperSliverList {
  static SuperSliverList builder({
    ListController? listController,
    required NullableIndexedWidgetBuilder itemBuilder,
    required int itemCount,
  }) =>
      SuperSliverList(
        listController: listController,
        delegate: SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        ),
        extentPrecalculationPolicy: AlwaysPrecalculateExtentPolicy(),
        layoutKeptAliveChildren: true,
      );
}

class AlwaysPrecalculateExtentPolicy extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) => true;
}
