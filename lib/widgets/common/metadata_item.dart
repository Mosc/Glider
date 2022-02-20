import 'package:flutter/material.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MetadataItem extends HookConsumerWidget {
  const MetadataItem(
      {Key? key, required this.icon, this.text, this.highlight = false})
      : super(key: key);

  final IconData icon;
  final String? text;
  final bool highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color? color =
        highlight ? Theme.of(context).colorScheme.primary : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: textTheme.bodyMedium?.scaledFontSize(context),
            color: color,
          ),
          if (text != null) ...<Widget>[
            const SizedBox(width: 4),
            Text(
              text!,
              style: textTheme.bodySmall?.copyWith(
                color: color ?? textTheme.bodyMedium?.color,
              ),
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
