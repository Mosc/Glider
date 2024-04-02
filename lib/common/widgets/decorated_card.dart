import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';

const _borderRadius = BorderRadius.all(Radius.circular(12));

class DecoratedCard extends StatelessWidget {
  const DecoratedCard.elevated({
    super.key,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.child,
  }) : _type = _CardType.elevated;

  const DecoratedCard.filled({
    super.key,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.child,
  }) : _type = _CardType.filled;

  const DecoratedCard.outlined({
    super.key,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.child,
  }) : _type = _CardType.outlined;

  final _CardType _type;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _type.color(context),
      elevation: _type.elevation,
      shape: _type.shape(context),
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: padding ?? AppSpacing.defaultTilePadding,
          child: child,
        ),
      ),
    );
  }
}

enum _CardType {
  elevated,
  filled(elevation: 0),
  outlined(elevation: 0);

  const _CardType({this.elevation});

  final double? elevation;

  Color? color(BuildContext context) => switch (this) {
        _CardType.filled =>
          Theme.of(context).colorScheme.surfaceContainerHighest,
        _ => null,
      };

  ShapeBorder? shape(BuildContext context) => switch (this) {
        _CardType.outlined => RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
            borderRadius: _borderRadius,
          ),
        _ => null,
      };
}
