import 'package:flutter/widgets.dart';

class SmoothAnimatedSwitcher extends StatelessWidget {
  const SmoothAnimatedSwitcher({
    Key key,
    @required this.condition,
    @required this.child,
    this.transitionBuilder,
    this.axis = Axis.vertical,
  }) : super(key: key);

  final bool condition;
  final Widget child;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final Axis axis;

  Widget _defaultTransitionBuilder(Widget child, Animation<double> animation) {
    return SizeTransition(
      axis: axis,
      axisAlignment: -1,
      sizeFactor: animation,
      child: fadeTransitionBuilder(child, animation),
    );
  }

  static Widget fadeTransitionBuilder(
      Widget child, Animation<double> animation) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget _defaultLayoutBuilder(
      Widget currentChild, List<Widget> previousChildren) {
    return Stack(
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: transitionBuilder ?? _defaultTransitionBuilder,
      layoutBuilder: _defaultLayoutBuilder,
      child: condition ? child : const SizedBox.shrink(),
    );
  }
}
