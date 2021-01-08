import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:glider/widgets/common/block.dart';

class Experimental extends StatelessWidget {
  const Experimental({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Block(
      child: Row(
        children: <Widget>[
          Icon(
            FluentIcons.warning_24_regular,
            size: Theme.of(context).textTheme.bodyText2.fontSize,
          ),
          const SizedBox(width: 12),
          const Text('This feature is experimental. Things may go wrong.'),
        ],
      ),
    );
  }
}
