import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TileLoadingBlock extends HookConsumerWidget {
  const TileLoadingBlock({super.key, this.width, this.height, this.color});

  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color ??
            (kIsWeb ? Theme.of(context).colorScheme.surface : Colors.white),
      ),
    );
  }
}
