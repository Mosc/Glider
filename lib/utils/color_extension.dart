import 'package:flutter/material.dart';

extension ColorExtension on Color {
  bool get isDark => ThemeData.estimateBrightnessForColor(this).isDark;

  Color darken(double amount) {
    int darkenInt(int value) => (value * (1 - amount)).round();
    return Color.fromARGB(
      alpha,
      darkenInt(red),
      darkenInt(green),
      darkenInt(blue),
    );
  }

  Color lighten(double amount) {
    int lightenInt(int value) => value + ((255 - value) * amount).round();
    return Color.fromARGB(
      alpha,
      lightenInt(red),
      lightenInt(green),
      lightenInt(blue),
    );
  }
}

extension BrightnessExtension on Brightness {
  bool get isDark => this == Brightness.dark;
}
