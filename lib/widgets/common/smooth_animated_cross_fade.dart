import 'package:flutter/widgets.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SmoothAnimatedCrossFade extends HookConsumerWidget {
  const SmoothAnimatedCrossFade({
    Key? key,
    required this.condition,
    this.trueChild = const SizedBox.shrink(),
    this.falseChild = const SizedBox.shrink(),
    this.duration,
  }) : super(key: key);

  final bool condition;
  final Widget trueChild;
  final Widget falseChild;
  final Duration? duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedCrossFade(
      duration: duration ?? AnimationUtil.defaultDuration,
      firstCurve: Curves.easeIn,
      secondCurve: Curves.easeOut,
      sizeCurve: AnimationUtil.defaultCurve,
      alignment: AlignmentDirectional.topStart,
      crossFadeState:
          condition ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: trueChild,
      secondChild: falseChild,
    );
  }
}
