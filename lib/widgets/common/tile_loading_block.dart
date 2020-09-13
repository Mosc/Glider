import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TileLoadingBlock extends StatelessWidget {
  const TileLoadingBlock({Key key, this.width, this.height}) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Shimmer(
      color: colorScheme.surface.withOpacity(0.3),
      duration: const Duration(seconds: 5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: colorScheme.surface.withOpacity(0.2),
        ),
      ),
    );
  }
}
