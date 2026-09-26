import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';

/// A fresh in-memory database, closed automatically after the test.
AppDatabase createTestDatabase() {
  final db = AppDatabase.forTesting(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  addTearDown(db.close);
  return db;
}

/// Controllable clock for deterministic timestamps.
class FakeClock {
  FakeClock(this.now);

  /// A fixed local time used across tests.
  factory FakeClock.standard() => FakeClock(DateTime(2026, 9, 26, 10, 30));

  DateTime now;

  DateTime call() => now;

  void advance(Duration duration) => now = now.add(duration);
}
