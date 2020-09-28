import 'package:flutter/widgets.dart';

class SmoothAnimatedSwitcher extends StatelessWidget {
  const SmoothAnimatedSwitcher({
    Key key,
    @required this.condition,
    this.trueChild = const SizedBox.shrink(),
    this.falseChild = const SizedBox.shrink(),
    this.transitionBuilder,
    this.axis = Axis.vertical,
  }) : super(key: key);

  final Widget trueChild;
  final Widget falseChild;
  final bool condition;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;
  final Axis axis;

  Widget _defaultTransitionBuilder(Widget child, Animation<double> animation) {
    return SizeTransition(
      axis: axis,
      axisAlignment: -1,
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: transitionBuilder ?? _defaultTransitionBuilder,
      child: condition ? trueChild : falseChild,
    );
  }
}
