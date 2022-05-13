import 'package:flutter/widgets.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SmoothAnimatedSize extends HookConsumerWidget {
  const SmoothAnimatedSize({
    super.key,
    required this.child,
    this.duration,
  });

  final Widget child;
  final Duration? duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSize(
      duration: duration ?? AnimationUtil.defaultDuration,
      curve: AnimationUtil.defaultCurve,
      alignment: AlignmentDirectional.topStart,
      child: child,
    );
  }
}
