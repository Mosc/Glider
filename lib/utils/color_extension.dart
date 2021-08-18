import 'package:flutter/material.dart';

extension ColorExtension on Color {
  bool get isDark => ThemeData.estimateBrightnessForColor(this).isDark;
}

extension BrightnessExtension on Brightness {
  bool get isDark => this == Brightness.dark;
}
