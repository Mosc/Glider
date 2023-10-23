import 'dart:math';

import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';

class IndentedWidget extends StatelessWidget {
  const IndentedWidget({
    super.key,
    required this.depth,
    required this.child,
  });

  final int depth;
  final Widget child;

  static const double _fadedOpacity = 0.25;

  @override
  Widget build(BuildContext context) {
    if (depth == 0) {
      return child;
    }

    final colorScheme = Theme.of(context).colorScheme;
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];

    return Stack(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: _getIndentation(depth)),
          child: child,
        ),
        for (var i = 1; i < depth; i++)
          PositionedDirectional(
            start: _getIndentation(i),
            top: 0,
            bottom: 0,
            child: VerticalDivider(
              width: 0,
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withOpacity(_fadedOpacity),
            ),
          ),
        PositionedDirectional(
          start: _getIndentation(depth),
          top: AppSpacing.s,
          bottom: AppSpacing.s,
          child: VerticalDivider(
            width: 0,
            color: _getCurrentColor(colors),
          ),
        ),
      ],
    );
  }

  Color _getCurrentColor(List<Color> colors) => colors[depth % colors.length];

  // Discussion threads can get deep to the point where simply indenting with a
  // fixed amount for every level can cause UI problems. We combat this by
  // reducing additional indentation for higher depths. At a depth of 16, half
  // of the indentation gets added compared to depth 1.
  double _getIndentation(int i) => AppSpacing.xl * pow(i, 0.75) - 1;
}
