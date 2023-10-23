import 'package:flutter/widgets.dart';

extension WidgetListExtension on List<Widget> {
  List<Widget> spaced({double? width, double? height}) => [
        ...expand(
          (widget) sync* {
            yield SizedBox(width: width, height: height);
            yield widget;
          },
        ).skip(1),
      ];
}
