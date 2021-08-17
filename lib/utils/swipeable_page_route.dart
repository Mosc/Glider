import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:glider/utils/animation_util.dart';

const Duration _transitionDuration = Duration(milliseconds: 200);

final Animatable<Offset> _rightMiddleTween =
    Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
final Animatable<Offset> _bottomUpTween =
    Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero);
final Animatable<double> _opacityTween = Tween<double>(begin: 1, end: 0.5);
final Animatable<double> _curveTween =
    CurveTween(curve: AnimationUtil.defaultCurve);

mixin SwipeablePageRouteMixin<T> on PageRoute<T> {
  @protected
  Widget buildContent(BuildContext context);

  @override
  Duration get transitionDuration => _transitionDuration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return nextRoute is SwipeablePageRouteMixin && !nextRoute.fullscreenDialog;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: buildContent(context),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return buildPageTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }

  static Widget buildPageTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    bool isUserGestureInProgress(PageRoute<dynamic> route) =>
        route.navigator!.userGestureInProgress;

    final bool userGestureInProgress = isUserGestureInProgress(route);
    final Animation<double> curvedAnimation =
        userGestureInProgress ? animation : animation.drive(_curveTween);
    final Animation<double> secondaryCurvedAnimation = userGestureInProgress
        ? secondaryAnimation
        : secondaryAnimation.drive(_curveTween);

    return FadeTransition(
      opacity: secondaryCurvedAnimation.drive(_opacityTween),
      child: route.fullscreenDialog
          ? SlideTransition(
              position: curvedAnimation.drive(_bottomUpTween),
              child: child,
            )
          : SlideTransition(
              position: curvedAnimation.drive(_rightMiddleTween),
              textDirection: Directionality.of(context),
              child: _SwipeableBackGestureDetector<T>(
                enabledCallback: () =>
                    !route.isFirst &&
                    !route.willHandlePopInternally &&
                    !route.hasScopedWillPopCallback &&
                    !route.fullscreenDialog &&
                    route.animation!.status == AnimationStatus.completed &&
                    route.secondaryAnimation!.status ==
                        AnimationStatus.dismissed &&
                    !isUserGestureInProgress(route),
                onStartPopGesture: () => _SwipeableBackGestureController<T>(
                  navigator: route.navigator!,
                  controller: route.controller!,
                ),
                child: child,
              ),
            ),
    );
  }
}

class _SwipeableBackGestureDetector<T> extends StatefulWidget {
  const _SwipeableBackGestureDetector({
    Key? key,
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  }) : super(key: key);

  final ValueGetter<bool> enabledCallback;
  final ValueGetter<_SwipeableBackGestureController<T>> onStartPopGesture;
  final Widget child;

  @override
  _SwipeableBackGestureDetectorState<T> createState() =>
      _SwipeableBackGestureDetectorState<T>();
}

class _SwipeableBackGestureDetectorState<T>
    extends State<_SwipeableBackGestureDetector<T>> {
  _SwipeableBackGestureController<T>? _backGestureController;

  late final HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = (_) {
        _backGestureController = widget.onStartPopGesture();
      }
      ..onUpdate = (DragUpdateDetails details) {
        _backGestureController?.dragUpdate(
          _convertToLogical(
            details.primaryDelta! / context.size!.width,
          ),
        );
      }
      ..onEnd = (DragEndDetails details) {
        _backGestureController?.dragEnd(
          _convertToLogical(
            details.velocity.pixelsPerSecond.dx / context.size!.width,
          ),
        );
        _backGestureController = null;
      }
      ..onCancel = () {
        _backGestureController?.dragEnd(0);
        _backGestureController = null;
      };
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0,
          width: max(
            Directionality.of(context) == TextDirection.ltr
                ? MediaQuery.of(context).padding.left
                : MediaQuery.of(context).padding.right,
            kMinInteractiveDimension,
          ),
          top: 0,
          bottom: 0,
          child: Listener(
            onPointerDown: (PointerDownEvent event) {
              if (widget.enabledCallback()) {
                _recognizer.addPointer(event);
              }
            },
            behavior: HitTestBehavior.translucent,
          ),
        )
      ],
    );
  }
}

class _SwipeableBackGestureController<T> {
  _SwipeableBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  void dragEnd(double velocity) {
    final bool animateForward =
        velocity.abs() >= 1 ? velocity <= 0 : controller.value > 0.5;

    if (animateForward) {
      final int droppedPageForwardAnimationTime = lerpDouble(
        _transitionDuration.inMilliseconds,
        0,
        controller.value,
      )!
          .floor();
      controller.animateTo(
        1,
        duration: Duration(milliseconds: droppedPageForwardAnimationTime),
        curve: AnimationUtil.defaultCurve,
      );
    } else {
      navigator.pop();

      if (controller.isAnimating) {
        final int droppedPageBackAnimationTime = lerpDouble(
          0,
          _transitionDuration.inMilliseconds,
          controller.value,
        )!
            .floor();
        controller.animateBack(
          0,
          duration: Duration(milliseconds: droppedPageBackAnimationTime),
          curve: AnimationUtil.defaultCurve,
        );
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener animationStatusCallback;
      animationStatusCallback = (AnimationStatus status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(animationStatusCallback);
      };
      controller.addStatusListener(animationStatusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}
