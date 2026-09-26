import 'package:flutter/material.dart';

/// Spacing scale (4pt grid). Use these instead of raw numbers for padding,
/// margins and gaps.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Default horizontal padding for page content.
  static const EdgeInsets page = EdgeInsets.symmetric(horizontal: md);
}

/// Corner radius scale.
abstract final class AppRadius {
  /// Chips, small badges.
  static const double sm = 8;

  /// Inputs, buttons, list tiles.
  static const double md = 12;

  /// Cards.
  static const double lg = 16;

  /// Bottom sheets, dialogs.
  static const double xl = 28;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
}

/// Material 3 window size classes and content width limits.
abstract final class AppLayout {
  /// Below this width the app uses a bottom NavigationBar.
  static const double mediumBreakpoint = 600;

  /// At or above this width the NavigationRail is extended.
  static const double expandedBreakpoint = 840;

  /// Page content never grows wider than this, so layouts stay readable on
  /// tablets and in landscape.
  static const double maxContentWidth = 640;
}

/// Motion tokens. Keep animations short and purposeful.
abstract final class AppMotion {
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration long = Duration(milliseconds: 400);

  static const Curve standard = Easing.standard;
  static const Curve emphasizedEnter = Easing.emphasizedDecelerate;
  static const Curve emphasizedExit = Easing.emphasizedAccelerate;
}
