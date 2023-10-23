import 'package:flutter/material.dart';

const double _defaultScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

class ModalBottomSheetPage<T> extends Page<T> {
  const ModalBottomSheetPage({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required this.builder,
    this.capturedThemes,
    this.barrierLabel,
    this.barrierOnTapHint,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showDragHandle,
    required this.isScrollControlled,
    this.scrollControlDisabledMaxHeightRatio =
        _defaultScrollControlDisabledMaxHeightRatio,
    this.transitionAnimationController,
    this.anchorPoint,
    this.useSafeArea = false,
  });

  final WidgetBuilder builder;
  final CapturedThemes? capturedThemes;
  final String? barrierLabel;
  final String? barrierOnTapHint;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final Color? modalBarrierColor;
  final bool isDismissible;
  final bool enableDrag;
  final bool? showDragHandle;
  final bool isScrollControlled;
  final double scrollControlDisabledMaxHeightRatio;
  final AnimationController? transitionAnimationController;
  final Offset? anchorPoint;
  final bool useSafeArea;

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
        builder: builder,
        capturedThemes: capturedThemes,
        barrierLabel: barrierLabel,
        barrierOnTapHint: barrierOnTapHint,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        modalBarrierColor: modalBarrierColor,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        showDragHandle: showDragHandle,
        isScrollControlled: isScrollControlled,
        scrollControlDisabledMaxHeightRatio:
            scrollControlDisabledMaxHeightRatio,
        settings: this,
        transitionAnimationController: transitionAnimationController,
        anchorPoint: anchorPoint,
        useSafeArea: useSafeArea,
      );
}
