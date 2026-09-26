import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/app.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

import 'test_database.dart';

/// Common window sizes (logical pixels) for layout tests.
abstract final class TestSizes {
  static const phone = Size(390, 844);
  static const tabletPortrait = Size(744, 1133);
  static const tabletLandscape = Size(1180, 820);
}

extension PumpApp on WidgetTester {
  /// Pumps the full app at [size] with an in-memory database and a fixed
  /// clock. [seed] runs against the database before the first frame.
  Future<AppDatabase> pumpApp({
    Size size = TestSizes.phone,
    FakeClock? clock,
    Future<void> Function(AppDatabase db)? seed,
  }) async {
    view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(view.reset);

    final db = createTestDatabase(closeOnTearDown: false);
    // Tear-downs run last-registered first: unmount the app (cancelling its
    // stream queries), then close the database in real async. Closing inside
    // the fake async zone can hang when a test fails with streams still open.
    addTearDown(() => runAsync(db.close));
    addTearDown(() => pumpWidget(const SizedBox.shrink()));
    if (seed != null) await seed(db);

    await pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue((clock ?? FakeClock.standard()).call),
        ],
        child: const JobTrackerApp(),
      ),
    );
    await pumpAndSettle();
    return db;
  }

  /// Taps a destination in the bottom navigation bar.
  Future<void> tapTab(String label) async {
    await tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );
    await pumpAndSettle();
  }
}
