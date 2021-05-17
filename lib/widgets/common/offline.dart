import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glider/utils/text_style_extension.dart';
import 'package:glider/widgets/common/block.dart';

class Offline extends StatelessWidget {
  const Offline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Block(
        child: Row(
          children: <Widget>[
            Icon(
              FluentIcons.cloud_offline_24_regular,
              size: textTheme.bodyText2?.scaledFontSize(context),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'You appear to be offline. '
                'The information shown may be incomplete or out of date.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
