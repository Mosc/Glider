import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DecoratedSpeedDial extends HookConsumerWidget {
  const DecoratedSpeedDial({
    Key? key,
    required this.visible,
    required this.icon,
    required this.children,
  }) : super(key: key);

  final bool visible;
  final IconData icon;
  final Iterable<DecoratedSpeedDialChild> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    return Hero(
      tag: 'fab',
      child: SpeedDial(
        children: children
            .map(
              (DecoratedSpeedDialChild child) => SpeedDialChild(
                label: child.label,
                labelBackgroundColor: theme.canvasColor,
                child: child.child,
                backgroundColor: theme.canvasColor,
                onTap: child.onTap,
              ),
            )
            .toList(growable: false),
        visible: visible,
        icon: icon,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        useRotationAnimation: false,
        animationSpeed: 100,
        spacing: 4,
      ),
    );
  }
}

class DecoratedSpeedDialChild {
  const DecoratedSpeedDialChild({
    required this.onTap,
    required this.label,
    required this.child,
  });

  final VoidCallback onTap;
  final String label;
  final Widget child;
}
