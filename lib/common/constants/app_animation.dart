import 'package:flutter/material.dart';

typedef Animation = ({Duration duration, Curve easing});

abstract final class AppAnimation {
  static const Animation emphasized = (
    duration: Durations.long2,
    // Emphasized easing is not yet defined in `Easing`.
    easing: Curves.easeInOutCubicEmphasized,
  );

  static const Animation standard = (
    duration: Durations.medium2,
    easing: Easing.standard,
  );
}
