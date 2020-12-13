import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class End extends StatelessWidget {
  const End({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17.5, horizontal: 16),
        child: Hero(
          tag: 'end',
          child: Column(
            children: <Widget>[
              Icon(
                FluentIcons.reading_list_24_regular,
                size: Theme.of(context).textTheme.bodyText2.fontSize * 2,
              ),
              const SizedBox(height: 12),
              Text(
                'Hic sunt dracones',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
