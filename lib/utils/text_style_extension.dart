import 'package:flutter/widgets.dart';

extension TextStyleExtension on TextStyle {
  double scaledFontSize(BuildContext context) =>
      fontSize * MediaQuery.of(context).textScaleFactor;
}
