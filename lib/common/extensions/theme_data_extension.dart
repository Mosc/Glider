import 'package:flutter/material.dart';

extension ThemeDataExtension on ThemeData {
  Color elevationToColor(int elevation) => ElevationOverlay.applySurfaceTint(
        colorScheme.surface,
        colorScheme.surfaceTint,
        elevation.toDouble(),
      );

  List<BoxShadow>? elevationToBoxShadow(int elevation) =>
      kElevationToShadow.containsKey(elevation)
          ? kElevationToShadow[elevation]
          : null;

  BoxDecoration elevationToBoxDecoration(int elevation) => BoxDecoration(
        color: elevationToColor(elevation),
        boxShadow: elevationToBoxShadow(elevation),
      );
}
