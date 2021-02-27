import 'package:flutter/widgets.dart';
import 'package:glider/utils/animation_util.dart';

class SmoothAnimatedSwitcher extends StatelessWidget {
  const SmoothAnimatedSwitcher({
    Key key,
    @required this.condition,
    @required this.child,
    this.duration,
  })  : transitionBuilder = AnimationUtil.fadeTransitionBuilder,
        super(key: key);

  const SmoothAnimatedSwitcher.vertical({
    Key key,
    @required this.condition,
    @required this.child,
    this.duration,
  })  : transitionBuilder = AnimationUtil.verticalFadeTransitionBuilder,
        super(key: key);

  const SmoothAnimatedSwitcher.horizontal({
    Key key,
    @required this.condition,
    @required this.child,
    this.duration,
  })  : transitionBuilder = AnimationUtil.horizontalFadeTransitionBuilder,
        super(key: key);

  final bool condition;
  final Widget child;
  final Duration duration;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

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
      duration: duration ?? AnimationUtil.defaultDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: transitionBuilder,
      layoutBuilder: _defaultLayoutBuilder,
      child: condition ? child : const SizedBox.shrink(),
    );
  }
}
