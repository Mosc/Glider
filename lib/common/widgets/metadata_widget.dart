import 'package:flutter/material.dart';
import 'package:glider/common/constants/app_spacing.dart';
import 'package:glider/common/extensions/widget_list_extension.dart';

const _iconSize = 16.0;

class MetadataWidget extends StatelessWidget {
  const MetadataWidget({
    super.key,
    this.icon,
    this.label,
    this.color,
  });

  final IconData? icon;
  final Widget? label;
  final Color? color;

  static const horizontalPadding =
      EdgeInsetsDirectional.only(end: AppSpacing.m);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Icon(
            icon,
            size: _iconSize,
            color: color,
          ),
        if (label != null)
          Flexible(
            child: DefaultTextStyle(
              style:
                  Theme.of(context).textTheme.bodySmall!.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: label!,
            ),
          ),
      ].spaced(width: AppSpacing.s),
    );
  }
}
