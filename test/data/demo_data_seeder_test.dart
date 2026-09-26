import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/seed/demo_data_seeder.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late DemoDataSeeder seeder;

  setUp(() {
    db = createTestDatabase();
    clock = FakeClock.standard();
    seeder = DemoDataSeeder(db, clock: clock.call);
  });

  test('seeds an empty database only once', () async {
    expect(await seeder.seedIfEmpty(), isTrue);
    final count = await db.applications.count().getSingle();
    expect(count, greaterThan(10));

    expect(await seeder.seedIfEmpty(), isFalse);
    expect(await db.applications.count().getSingle(), count);
  });

  test('seeded data is consistent with repository invariants', () async {
    await seeder.seed();
    final repo = ApplicationRepository(db);

    final applications = await repo.watchAll().first;
    for (final app in applications) {
      final history = await repo.watchStatusHistory(app.id).first;

      expect(history.first.fromStatus, isNull, reason: app.companyName);
      expect(history.last.toStatus, app.status, reason: app.companyName);
      final everSubmitted = history.any(
        (c) => c.toStatus != ApplicationStatus.saved,
      );
      expect(app.isSubmitted, everSubmitted, reason: app.companyName);
    }

    // Covers every status so the UI and analytics can be exercised.
    expect(
      applications.map((a) => a.status).toSet(),
      containsAll(ApplicationStatus.values.toSet()),
    );
  });

  test('includes an upcoming interview with a linked checklist', () async {
    await seeder.seed();

    final upcoming = await (db.select(
      db.interviews,
    )..where((t) => t.scheduledAt.isBiggerThanValue(clock.now.toUtc()))).get();
    expect(upcoming, isNotEmpty);

    final linked = await (db.select(
      db.checklistItems,
    )..where((t) => t.interviewId.equals(upcoming.first.id))).get();
    expect(linked, isNotEmpty);
  });
}
