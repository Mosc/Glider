import 'package:flutter/widgets.dart';

class SmoothAnimatedCrossFade extends StatelessWidget {
  const SmoothAnimatedCrossFade({
    Key key,
    @required this.condition,
    this.trueChild = const SizedBox.shrink(),
    this.falseChild = const SizedBox.shrink(),
  }) : super(key: key);

  final bool condition;
  final Widget trueChild;
  final Widget falseChild;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 400),
      firstCurve: Curves.easeIn,
      secondCurve: Curves.easeOut,
      sizeCurve: Curves.easeInOut,
      alignment: AlignmentDirectional.topStart,
      crossFadeState:
          condition ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: trueChild,
      secondChild: falseChild,
    );
  }
}
