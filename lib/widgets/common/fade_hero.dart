import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FadeHero extends HookConsumerWidget {
  const FadeHero({
    Key? key,
    required this.tag,
    required this.child,
  }) : super(key: key);

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (_, Animation<double> animation, __,
              BuildContext fromHeroContext, BuildContext toHeroContext) =>
          Stack(
        children: <Widget>[
          FadeTransition(
            opacity: ReverseAnimation(animation),
            child: toHeroContext.widget,
          ),
          FadeTransition(
            opacity: animation,
            child: fromHeroContext.widget,
          ),
        ],
      ),
      child: child,
    );
  }
}
