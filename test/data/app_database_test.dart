import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = createTestDatabase());

  test('enables foreign keys on open', () async {
    final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(row.read<int>('foreign_keys'), 1);
  });

  test('rejects children that reference a missing application', () async {
    final now = DateTime.utc(2026);
    await expectLater(
      db
          .into(db.interviews)
          .insert(
            InterviewsCompanion.insert(
              applicationId: 999,
              title: 'HR Interview',
              format: InterviewFormat.video,
              scheduledAt: now,
              createdAt: now,
              updatedAt: now,
            ),
          ),
      throwsA(anything),
    );
  });

  test('rejects salary_min greater than salary_max', () async {
    final now = DateTime.utc(2026);
    await expectLater(
      db
          .into(db.applications)
          .insert(
            ApplicationsCompanion.insert(
              companyName: 'Acme',
              positionTitle: 'Developer',
              salaryMin: const Value(10),
              salaryMax: const Value(5),
              createdAt: now,
              updatedAt: now,
            ),
          ),
      throwsA(anything),
    );
  });

  test('stores DateTime as UTC text with millisecond precision', () async {
    final timestamp = DateTime.utc(2026, 9, 26, 3, 30, 15, 123);
    await db
        .into(db.applications)
        .insert(
          ApplicationsCompanion.insert(
            companyName: 'Acme',
            positionTitle: 'Developer',
            createdAt: timestamp,
            updatedAt: timestamp,
          ),
        );

    final raw = await db
        .customSelect('SELECT created_at FROM applications')
        .getSingle();
    expect(raw.read<String>('created_at'), contains('2026-09-26T03:30:15.123'));

    final row = await db.select(db.applications).getSingle();
    expect(row.createdAt, timestamp);
    expect(row.createdAt.isUtc, isTrue);
  });
}
