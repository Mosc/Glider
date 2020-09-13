import 'package:flutter/material.dart';

class Separator extends Divider {
  const Separator({Key key})
      : super(key: key, indent: _indent, endIndent: _indent, height: 1);

  static const double _indent = 8;
}
