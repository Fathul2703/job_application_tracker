import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/core/theme/app_theme.dart';
import 'package:job_application_tracker/core/theme/status_colors.dart';

/// WCAG 2.x contrast ratio between two opaque colors.
double contrastRatio(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  group('AppTheme', () {
    test('light and dark themes use Material 3 with matching brightness', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.light.colorScheme.brightness, Brightness.light);
      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
    });

    test('registers the matching StatusColors extension', () {
      expect(AppTheme.light.extension<StatusColors>(), StatusColors.light);
      expect(AppTheme.dark.extension<StatusColors>(), StatusColors.dark);
    });
  });

  group('StatusColors', () {
    for (final (name, palette) in [
      ('light', StatusColors.light),
      ('dark', StatusColors.dark),
    ]) {
      test('$name tones meet WCAG AA contrast (4.5:1)', () {
        for (final tone in palette.all) {
          expect(
            contrastRatio(tone.foreground, tone.background),
            greaterThanOrEqualTo(4.5),
            reason: '${tone.foreground} on ${tone.background}',
          );
        }
      });
    }

    test('lerp returns the endpoints at t = 0 and t = 1', () {
      const light = StatusColors.light;
      const dark = StatusColors.dark;

      expect(light.lerp(dark, 0).offer.background, light.offer.background);
      expect(light.lerp(dark, 1).offer.background, dark.offer.background);
    });
  });
}
