import 'package:flutter/material.dart';
import 'package:glider/models/slidable_action.dart';

class Slidable extends StatelessWidget {
  const Slidable({
    @required Key key,
    this.startToEndAction,
    this.endToStartAction,
    this.child,
  })  : assert(startToEndAction != null || endToStartAction != null,
            'Must provide either a startToEndAction or an endToStartAction'),
        super(key: key);

  final Widget child;
  final SlidableAction startToEndAction;
  final SlidableAction endToStartAction;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      background: startToEndAction != null
          ? Container(
              color: startToEndAction.color,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Icon(startToEndAction.icon),
              ),
            )
          : null,
      secondaryBackground: endToStartAction != null
          ? Container(
              color: endToStartAction.color,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Icon(endToStartAction.icon),
              ),
            )
          : null,
      direction: startToEndAction != null
          ? endToStartAction != null
              ? DismissDirection.horizontal
              : DismissDirection.startToEnd
          : DismissDirection.endToStart,
      confirmDismiss: (_) {
        startToEndAction.action?.call();
        return Future<bool>.value(false);
      },
      resizeDuration: null,
      child: child,
    );
  }
}
