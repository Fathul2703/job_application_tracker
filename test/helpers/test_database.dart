import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';

/// A fresh in-memory database. Closed automatically after the test unless
/// [closeOnTearDown] is false (widget tests close it themselves, see
/// `pumpApp`).
AppDatabase createTestDatabase({bool closeOnTearDown = true}) {
  final db = AppDatabase.forTesting(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  if (closeOnTearDown) addTearDown(db.close);
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
