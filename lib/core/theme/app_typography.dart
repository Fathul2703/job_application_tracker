import 'package:flutter/material.dart';

/// Typography overrides on top of the Material 3 type scale.
///
/// Sizes and colors come from the M3 defaults, which ThemeData merges with
/// [textTheme]. Weights and tracking are tuned for Inter: the M3 tracking
/// values were designed for Roboto and look loose with Inter.
abstract final class AppTypography {
  /// Bundled Inter variable font (assets/fonts, OFL). `FontWeight` drives
  /// its `wght` axis, so no per-weight files are needed.
  static const String fontFamily = 'Inter';

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -1),
    displayMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.8),
    displaySmall: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6),
    headlineLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.6),
    headlineMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.5),
    headlineSmall: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.4),
    titleLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.2),
    titleMedium: TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.1),
    titleSmall: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0),
    bodyLarge: TextStyle(letterSpacing: 0),
    bodyMedium: TextStyle(letterSpacing: 0),
    bodySmall: TextStyle(letterSpacing: 0.1),
    labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0),
    labelMedium: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.1),
    labelSmall: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.2),
  );
}

extension AppTextStyleX on TextStyle {
  /// Fixed-width digits, for numbers in table columns.
  TextStyle get tabular =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
