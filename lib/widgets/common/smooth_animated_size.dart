import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SmoothAnimatedSize extends HookWidget {
  const SmoothAnimatedSize({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: AlignmentDirectional.topStart,
      vsync: useSingleTickerProvider(),
      child: child,
    );
  }
}
