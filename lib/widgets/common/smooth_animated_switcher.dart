import 'package:flutter/widgets.dart';

class SmoothAnimatedSwitcher extends StatelessWidget {
  const SmoothAnimatedSwitcher({
    Key key,
    @required this.condition,
    @required this.child,
  })  : transitionBuilder = _defaultTransitionBuilder,
        super(key: key);

  const SmoothAnimatedSwitcher.vertical({
    Key key,
    @required this.condition,
    @required this.child,
  })  : transitionBuilder = _verticalTransitionBuilder,
        super(key: key);

  const SmoothAnimatedSwitcher.horizontal({
    Key key,
    @required this.condition,
    @required this.child,
  })  : transitionBuilder = _horizontalTransitionBuilder,
        super(key: key);

  final bool condition;
  final Widget child;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

  static Widget _defaultTransitionBuilder(
      Widget child, Animation<double> animation) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget _horizontalTransitionBuilder(
      Widget child, Animation<double> animation) {
    return _sizeTransitionBuilder(child, animation, Axis.horizontal);
  }

  static Widget _verticalTransitionBuilder(
      Widget child, Animation<double> animation) {
    return _sizeTransitionBuilder(child, animation, Axis.vertical);
  }

  static Widget _sizeTransitionBuilder(
      Widget child, Animation<double> animation, Axis axis) {
    return SizeTransition(
      axis: axis,
      axisAlignment: -1,
      sizeFactor: animation,
      child: _defaultTransitionBuilder(child, animation),
    );
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
      transitionBuilder: transitionBuilder,
      layoutBuilder: _defaultLayoutBuilder,
      child: condition ? child : const SizedBox.shrink(),
    );
  }
}
