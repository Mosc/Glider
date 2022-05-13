import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScrollableBottomSheet extends HookConsumerWidget {
  const ScrollableBottomSheet({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ListView(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: children,
      ),
    );
  }
}
