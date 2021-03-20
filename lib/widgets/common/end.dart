import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glider/utils/text_style_extension.dart';

class End extends StatelessWidget {
  const End({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double? scaledFontSize =
        Theme.of(context).textTheme.bodyText2?.scaledFontSize(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
        child: Hero(
          tag: 'end',
          child: Column(
            children: <Widget>[
              Icon(
                FluentIcons.pulse_24_regular,
                size: scaledFontSize != null ? scaledFontSize * 2 : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
