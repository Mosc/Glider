import 'package:flutter/material.dart';

class End extends StatelessWidget {
  const End({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
        child: Hero(
          tag: 'end',
          child: Column(
            children: <Widget>[
              Icon(
                Icons.bedtime,
                size: Theme.of(context).textTheme.bodyText2.fontSize * 2,
              ),
              const SizedBox(height: 12),
              Text(
                "You've reached the end",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
