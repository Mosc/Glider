import 'package:flutter/material.dart';
import 'package:glider/app_theme.dart';
import 'package:glider/providers/persistence_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IndentedTile extends HookConsumerWidget {
  const IndentedTile({
    super.key,
    required this.indentation,
    required this.child,
  });

  final int indentation;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (indentation == 0) {
      return child;
    }

    final double indentationPadding = indentation.toDouble() * 8;

    Color determineDividerColor() {
      final List<Color> colors = AppTheme.themeColors.toList(growable: false);
      final Color? themeColor = ref.watch(themeColorProvider).value;
      final int initialOffset =
          themeColor != null ? colors.indexOf(themeColor) : 0;
      final int offset =
          (initialOffset + (indentation - 1) * 2) % colors.length;
      return colors[offset];
    }

    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsetsDirectional.only(start: indentationPadding),
          child: child,
        ),
        PositionedDirectional(
          start: indentationPadding - 1,
          top: 4,
          bottom: 4,
          child: VerticalDivider(
            width: 1,
            thickness: 1,
            color: determineDividerColor(),
          ),
        ),
      ],
    );
  }
}
