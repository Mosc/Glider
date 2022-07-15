import 'package:flutter/widgets.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SmoothAnimatedSwitcher extends HookConsumerWidget {
  const SmoothAnimatedSwitcher({
    super.key,
    required this.condition,
    required this.child,
    this.duration,
  }) : transitionBuilder = AnimationUtil.fadeTransitionBuilder;

  const SmoothAnimatedSwitcher.vertical({
    super.key,
    required this.condition,
    required this.child,
    this.duration,
  }) : transitionBuilder = AnimationUtil.verticalFadeTransitionBuilder;

  const SmoothAnimatedSwitcher.horizontal({
    super.key,
    required this.condition,
    required this.child,
    this.duration,
  }) : transitionBuilder = AnimationUtil.horizontalFadeTransitionBuilder;

  const SmoothAnimatedSwitcher.all({
    super.key,
    required this.condition,
    required this.child,
    this.duration,
  }) : transitionBuilder = AnimationUtil.allFadeTransitionBuilder;

  final bool condition;
  final Widget child;
  final Duration? duration;
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

  static Widget _defaultLayoutBuilder(
      Widget? currentChild, List<Widget> previousChildren) {
    return Stack(
      children: <Widget>[
        ...previousChildren,
        if (currentChild != null) currentChild,
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
      duration: duration ?? AnimationUtil.defaultDuration,
      switchInCurve: AnimationUtil.defaultCurve,
      switchOutCurve: AnimationUtil.defaultCurve,
      transitionBuilder: transitionBuilder,
      layoutBuilder: _defaultLayoutBuilder,
      child: condition ? child : const SizedBox.shrink(),
    );
  }
}
