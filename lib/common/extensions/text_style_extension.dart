import 'package:flutter/widgets.dart';

extension TextStyleExtension on TextStyle {
  double? scaledFontSize(BuildContext context) => fontSize != null
      ? MediaQuery.textScalerOf(context).scale(fontSize!)
      : null;

  double? leading(BuildContext context) => fontSize != null && height != null
      ? scaledFontSize(context)! * (height! - 1)
      : null;
}
