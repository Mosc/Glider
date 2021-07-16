import 'package:flutter/material.dart';

class ScrollableBottomSheet extends StatelessWidget {
  const ScrollableBottomSheet({Key? key, required this.children})
      : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
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
