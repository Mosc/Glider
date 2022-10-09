import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Tag extends HookConsumerWidget {
  const Tag({
    super.key,
    required this.text,
    this.color,
    this.backgroundColor,
    this.borderColor,
  });

  final String text;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor != null || backgroundColor != null
            ? Border.all(color: borderColor ?? backgroundColor!)
            : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(color: color),
      ),
    );
  }
}
