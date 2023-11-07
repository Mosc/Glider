import 'package:flutter/painting.dart';

abstract final class AppSpacing {
  static const _baseUnit = 4.0;

  static const s = _baseUnit;

  static const m = _baseUnit * 2;

  static const l = _baseUnit * 3;

  static const xl = _baseUnit * 4;

  static const xxl = _baseUnit * 6;

  static const defaultTilePadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: m,
  );

  static const defaultShadowPadding = EdgeInsets.all(2);

  static const floatingActionButtonPageBottomPadding =
      EdgeInsets.only(bottom: 88);

  static const twoSmallFloatingActionButtonsPageBottomPadding =
      EdgeInsets.only(bottom: 136);
}
