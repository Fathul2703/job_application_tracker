import 'package:flutter/material.dart';

/// Colors for charts that the Material scheme doesn't provide.
///
/// The emphasis series uses `colorScheme.primary`. [primaryMuted] is a
/// lighter (light mode) / darker (dark mode) step of the same hue for the
/// de-emphasised part of a two-step series. Both pairs were checked with the
/// dataviz palette validator (`--ordinal`) against the card surface:
/// light #3525cd / #9994f2 on #f6f2fa (2.41:1), dark #c3c0ff / #5a5892 on
/// #1b1b21 (2.65:1). Re-run it if the seed color changes.
@immutable
class ChartColors extends ThemeExtension<ChartColors> {
  const ChartColors({required this.primaryMuted});

  final Color primaryMuted;

  static const light = ChartColors(primaryMuted: Color(0xFF9994F2));
  static const dark = ChartColors(primaryMuted: Color(0xFF5A5892));

  @override
  ChartColors copyWith({Color? primaryMuted}) =>
      ChartColors(primaryMuted: primaryMuted ?? this.primaryMuted);

  @override
  ChartColors lerp(ChartColors? other, double t) => other == null
      ? this
      : ChartColors(
          primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
        );
}
