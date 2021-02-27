import 'package:flutter/widgets.dart';

class AnimationUtil {
  const AnimationUtil._();

  static const Duration defaultDuration = Duration(milliseconds: 400);

  static Widget fadeTransitionBuilder(
      Widget child, Animation<double> animation) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget horizontalFadeTransitionBuilder(
      Widget child, Animation<double> animation) {
    return _sizeFadeTransitionBuilder(child, animation, Axis.horizontal);
  }

  static Widget verticalFadeTransitionBuilder(
      Widget child, Animation<double> animation) {
    return _sizeFadeTransitionBuilder(child, animation, Axis.vertical);
  }

  static Widget _sizeFadeTransitionBuilder(
      Widget child, Animation<double> animation, Axis axis) {
    return SizeTransition(
      axis: axis,
      axisAlignment: -1,
      sizeFactor: animation,
      child: fadeTransitionBuilder(child, animation),
    );
  }
}
