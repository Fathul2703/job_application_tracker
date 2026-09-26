import 'package:flutter/material.dart';

/// Typography overrides on top of the Material 3 type scale.
///
/// Only weights and tracking are set here; sizes and colors come from the
/// M3 defaults, which ThemeData merges with this [textTheme].
abstract final class AppTypography {
  /// Custom font family. `null` uses the platform font (Roboto on Android,
  /// SF Pro on iOS). A bundled font will be added during the polish phase.
  static const String? fontFamily = null;

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
    displayMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
    displaySmall: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.25),
    headlineLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.25),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
    ),
    headlineSmall: TextStyle(fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontWeight: FontWeight.w600),
    labelLarge: TextStyle(fontWeight: FontWeight.w600),
  );
}

extension AppTextStyleX on TextStyle {
  /// Fixed-width digits, for statistics and numbers that change in place.
  TextStyle get tabular =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
