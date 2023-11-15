import 'package:flutter/material.dart' as material;
import 'package:glider_domain/glider_domain.dart';

extension ThemeModeExtension on ThemeMode {
  material.ThemeMode toMaterialThemeMode() => switch (this) {
        ThemeMode.system => material.ThemeMode.system,
        ThemeMode.light => material.ThemeMode.light,
        ThemeMode.dark => material.ThemeMode.dark,
      };
}
