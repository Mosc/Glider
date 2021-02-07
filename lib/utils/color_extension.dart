import 'package:flutter/material.dart';

extension ColorExtension on Color {
  bool get isDark =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.dark;
}
