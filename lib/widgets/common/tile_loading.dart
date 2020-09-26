import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TileLoading extends StatelessWidget {
  const TileLoading({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surface,
      highlightColor: colorScheme.surface.withOpacity(0.2),
      child: child,
    );
  }
}
