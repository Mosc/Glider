import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({
    Key key,
    this.vertical = false,
    this.startIndent = _defaultIndent,
    this.endIndent = _defaultIndent,
  }) : super(key: key);

  static const double _size = 1;
  static const double _defaultIndent = 8;

  final bool vertical;
  final double startIndent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return VerticalDivider(
        width: _size,
        indent: startIndent,
        endIndent: endIndent,
      );
    } else {
      return Divider(
        height: _size,
        indent: startIndent,
        endIndent: endIndent,
      );
    }
  }
}
