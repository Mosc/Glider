import 'package:flutter/widgets.dart';

class AnimationUtil {
  const AnimationUtil._();

  static const Duration defaultDuration = Duration(milliseconds: 300);

  static const Curve defaultCurve = Curves.easeInOut;

  static Widget fadeTransitionBuilder(
      Widget child, Animation<double> animation) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget horizontalFadeTransitionBuilder(
      Widget child, Animation<double> animation) {
    return _sizeTransitionBuilder(
      fadeTransitionBuilder(child, animation),
      animation,
      Axis.horizontal,
    );
  }

  static Widget verticalFadeTransitionBuilder(
      Widget child, Animation<double> animation) {
    return _sizeTransitionBuilder(
      fadeTransitionBuilder(child, animation),
      animation,
      Axis.vertical,
    );
  }

  static Widget allFadeTransitionBuilder(
      Widget child, Animation<double> animation) {
    return _sizeTransitionBuilder(
      verticalFadeTransitionBuilder(child, animation),
      animation,
      Axis.horizontal,
    );
  }

  static Widget _sizeTransitionBuilder(
      Widget child, Animation<double> animation, Axis axis) {
    return SizeTransition(
      axis: axis,
      axisAlignment: -1,
      sizeFactor: animation,
      child: fadeTransitionBuilder(child, animation),
    );
  }
}
