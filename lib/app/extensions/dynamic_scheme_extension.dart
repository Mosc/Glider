import 'package:material_color_utilities/material_color_utilities.dart';

extension DynamicSchemeExtension on DynamicScheme {
  CorePalette toColorPalette() => CorePalette.fromList(
        [
          ...primaryPalette.asList,
          ...secondaryPalette.asList,
          ...tertiaryPalette.asList,
          ...neutralPalette.asList,
          ...neutralVariantPalette.asList,
        ],
      );
}
