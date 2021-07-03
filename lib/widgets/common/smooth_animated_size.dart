import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/utils/animation_util.dart';

class SmoothAnimatedSize extends HookWidget {
  const SmoothAnimatedSize({
    Key? key,
    required this.child,
    this.duration,
  }) : super(key: key);

  final Widget child;
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: duration ?? AnimationUtil.defaultDuration,
      curve: Curves.easeInOut,
      alignment: AlignmentDirectional.topStart,
      child: child,
    );
  }
}
