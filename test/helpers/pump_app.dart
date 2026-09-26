import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/app.dart';

/// Common window sizes (logical pixels) for layout tests.
abstract final class TestSizes {
  static const phone = Size(390, 844);
  static const tabletPortrait = Size(744, 1133);
  static const tabletLandscape = Size(1180, 820);
}

extension PumpApp on WidgetTester {
  /// Pumps the full app inside a fresh [ProviderScope] at [size].
  Future<void> pumpApp({Size size = TestSizes.phone}) async {
    view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(view.reset);

    await pumpWidget(const ProviderScope(child: JobTrackerApp()));
    await pumpAndSettle();
  }
}
