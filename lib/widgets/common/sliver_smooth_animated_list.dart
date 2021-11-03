import 'package:flutter/widgets.dart';
import 'package:glider/utils/animation_util.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';

class SliverSmoothAnimatedList<T extends Object> extends StatelessWidget {
  const SliverSmoothAnimatedList({
    Key? key,
    required this.items,
    required this.builder,
  }) : super(key: key);

  final Iterable<T> items;
  final Widget Function(BuildContext, T, int) builder;

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      top: false,
      bottom: false,
      sliver: SliverImplicitlyAnimatedList<T>(
        items: items.toList(growable: false),
        areItemsTheSame: (T a, T b) => a == b,
        itemBuilder: (BuildContext context, Animation<double> animation, T item,
                int index) =>
            AnimationUtil.verticalFadeTransitionBuilder(
          builder(context, item, index),
          CurvedAnimation(
            parent: animation,
            curve: AnimationUtil.defaultCurve,
          ),
        ),
        insertDuration: AnimationUtil.defaultDuration,
        removeDuration: AnimationUtil.defaultDuration,
        updateDuration: AnimationUtil.defaultDuration,
        spawnIsolate: false,
      ),
    );
  }
}
