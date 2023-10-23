import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/l10n/extensions/app_localizations_extension.dart';
import 'package:go_router/go_router.dart';

const _totalColors = 20;

final _colors = [
  for (var i = 0; i < _totalColors; i++)
    HSVColor.fromAHSV(1, 360 / _totalColors * i, 0.5, 1).toColor(),
];

const _iconSize = 40.0;

class ThemeColorDialog extends StatelessWidget {
  const ThemeColorDialog({
    this.selectedColor,
    super.key,
  });

  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.themeColor),
      contentPadding: AppSpacing.defaultTilePadding,
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.extent(
          maxCrossAxisExtent: 64,
          shrinkWrap: true,
          children: [
            for (final color in _colors)
              IconButton(
                icon: Icon(
                  Icons.circle_outlined,
                  color: color,
                  size: _iconSize,
                ),
                selectedIcon: Icon(
                  Icons.circle,
                  color: color,
                  size: _iconSize,
                ),
                isSelected: color == selectedColor,
                padding: const EdgeInsets.all(AppSpacing.m),
                onPressed: () => context.pop(color),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    );
  }
}
