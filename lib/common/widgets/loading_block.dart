import 'package:flutter/material.dart';

class LoadingBlock extends StatelessWidget {
  const LoadingBlock({super.key, this.width, this.height});

  final double? width;
  final double? height;

  static const double opacity = 0.25;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: Theme.of(context).colorScheme.outline.withOpacity(opacity),
      ),
    );
  }
}
