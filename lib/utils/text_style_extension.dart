import 'package:flutter/widgets.dart';

extension TextStyleExtension on TextStyle {
  double? scaledFontSize(BuildContext context) => fontSize != null
      ? fontSize! * MediaQuery.of(context).textScaleFactor
      : null;

  double? lineHeight(BuildContext context) => fontSize != null && height != null
      ? scaledFontSize(context)! * height!
      : null;

  double? leading(BuildContext context) => fontSize != null && height != null
      ? lineHeight(context)! - scaledFontSize(context)!
      : null;
}
