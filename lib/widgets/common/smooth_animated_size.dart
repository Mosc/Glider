import 'package:flutter/widgets.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SmoothAnimatedSize extends HookConsumerWidget {
  const SmoothAnimatedSize({
    Key? key,
    required this.child,
    this.duration,
  }) : super(key: key);

  final Widget child;
  final Duration? duration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSize(
      duration: duration ?? AnimationUtil.defaultDuration,
      curve: Curves.easeInOut,
      alignment: AlignmentDirectional.topStart,
      child: child,
    );
  }
}
