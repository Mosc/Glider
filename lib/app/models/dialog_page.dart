import 'package:flutter/material.dart';

class DialogPage<T> extends Page<T> {
  const DialogPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required this.builder,
    this.themes,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.anchorPoint,
    this.traversalEdgeBehavior,
  });

  final WidgetBuilder builder;
  final CapturedThemes? themes;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final Offset? anchorPoint;
  final TraversalEdgeBehavior? traversalEdgeBehavior;

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
        context: context,
        builder: builder,
        themes: themes,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        settings: this,
        anchorPoint: anchorPoint,
        traversalEdgeBehavior: traversalEdgeBehavior,
      );
}
