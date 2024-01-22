import 'package:flutter/material.dart';

typedef Animation = ({Duration duration, Curve easing});

abstract final class AppAnimation {
  static Animation get emphasized => (
        duration: disableAnimations ? Duration.zero : Durations.long2,
        // Emphasized easing is not yet defined in `Easing`.
        easing: Curves.easeInOutCubicEmphasized,
      );

  static Animation get standard => (
        duration: disableAnimations ? Duration.zero : Durations.medium2,
        easing: Easing.standard,
      );

  static bool get disableAnimations =>
      WidgetsBinding.instance.disableAnimations;
}
