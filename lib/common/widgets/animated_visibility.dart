import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_animation.dart';

class AnimatedVisibility extends StatelessWidget {
  const AnimatedVisibility({
    super.key,
    required this.visible,
    this.padding = EdgeInsets.zero,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  }) : _replacement = const SizedBox.shrink();

  const AnimatedVisibility.vertical({
    super.key,
    required this.visible,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.topCenter,
    required this.child,
  }) : _replacement = const SizedBox(width: double.infinity);

  final bool visible;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final Widget child;
  final Widget _replacement;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          visible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: AnimatedPadding(
        padding: padding,
        duration: AppAnimation.standard.duration,
        curve: AppAnimation.standard.easing,
        child: child,
      ),
      secondChild: _replacement,
      alignment: alignment,
      duration: AppAnimation.standard.duration,
      firstCurve: AppAnimation.standard.easing,
      secondCurve: AppAnimation.standard.easing,
      sizeCurve: AppAnimation.standard.easing,
    );
  }
}
