import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/repositories/checklist_repository.dart';
import 'package:job_application_tracker/data/repositories/interview_repository.dart';
import 'package:job_application_tracker/data/repositories/note_repository.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/interview.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late ApplicationRepository repo;

  const draft = ApplicationDraft(
    companyName: '  Arunika Digital ',
    positionTitle: 'Flutter Developer',
    location: '  ',
    jobUrl: ' https://example.com/job ',
    workMode: WorkMode.hybrid,
    salaryMin: 12000000,
    salaryMax: 16000000,
  );

  setUp(() {
    db = createTestDatabase();
    clock = FakeClock.standard();
    repo = ApplicationRepository(db, clock: clock.call);
  });

  group('create', () {
    test('normalizes text and sets UTC timestamps', () async {
      final id = await repo.create(draft);
      final app = (await repo.getById(id))!;

      expect(app.companyName, 'Arunika Digital');
      expect(app.location, isNull);
      expect(app.jobUrl, 'https://example.com/job');
      expect(app.salaryCurrency, 'IDR');
      expect(app.status, ApplicationStatus.saved);
      expect(app.createdAt, clock.now.toUtc());
      expect(app.updatedAt.isUtc, isTrue);
    });

    test('records the initial status in history', () async {
      final id = await repo.create(draft);
      final history = await repo.watchStatusHistory(id).first;

      expect(history, hasLength(1));
      expect(history.single.fromStatus, isNull);
      expect(history.single.toStatus, ApplicationStatus.saved);
    });

    test('a saved application has no applied date', () async {
      final id = await repo.create(draft);
      expect((await repo.getById(id))!.appliedAt, isNull);
    });

    test('an applied application gets today as applied date', () async {
      final id = await repo.create(
        const ApplicationDraft(
          companyName: 'Acme',
          positionTitle: 'Developer',
          status: ApplicationStatus.applied,
        ),
      );
      expect((await repo.getById(id))!.appliedAt, DateTime.utc(2026, 9, 26));
    });

    test('keeps an explicit applied date and deadline as date-only', () async {
      final id = await repo.create(
        ApplicationDraft(
          companyName: 'Acme',
          positionTitle: 'Developer',
          status: ApplicationStatus.applied,
          appliedAt: DateTime(2026, 9, 1, 23, 45),
          deadlineAt: DateTime(2026, 10, 5, 8),
        ),
      );
      final app = (await repo.getById(id))!;
      expect(app.appliedAt, DateTime.utc(2026, 9, 1));
      expect(app.deadlineAt, DateTime.utc(2026, 10, 5));
    });

    test('rejects invalid drafts without writing anything', () async {
      await expectLater(
        repo.create(
          const ApplicationDraft(
            companyName: ' ',
            positionTitle: 'Developer',
            salaryMin: 20,
            salaryMax: 10,
          ),
        ),
        throwsA(
          isA<ValidationException>().having(
            (e) => e.problems,
            'problems',
            hasLength(2),
          ),
        ),
      );
      expect(await repo.watchAll().first, isEmpty);
    });
  });

  group('changeStatus', () {
    test('updates status, applied date and history', () async {
      final id = await repo.create(draft);
      clock.advance(const Duration(days: 2));

      await repo.changeStatus(id, ApplicationStatus.applied);

      final app = (await repo.getById(id))!;
      expect(app.status, ApplicationStatus.applied);
      expect(app.appliedAt, DateTime.utc(2026, 9, 28));
      expect(app.updatedAt, clock.now.toUtc());

      final history = await repo.watchStatusHistory(id).first;
      expect(history.map((c) => (c.fromStatus, c.toStatus)), [
        (null, ApplicationStatus.saved),
        (ApplicationStatus.saved, ApplicationStatus.applied),
      ]);
    });

    test('does not overwrite an existing applied date', () async {
      final id = await repo.create(draft);
      await repo.changeStatus(id, ApplicationStatus.applied);
      clock.advance(const Duration(days: 10));

      await repo.changeStatus(id, ApplicationStatus.interview);

      expect((await repo.getById(id))!.appliedAt, DateTime.utc(2026, 9, 26));
    });

    test('is a no-op when the status does not change', () async {
      final id = await repo.create(draft);
      await repo.changeStatus(id, ApplicationStatus.saved);

      expect(await repo.watchStatusHistory(id).first, hasLength(1));
    });

    test('throws NotFoundException for a missing application', () {
      expect(
        repo.changeStatus(42, ApplicationStatus.applied),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('update', () {
    test('replaces fields and records a status change', () async {
      final id = await repo.create(draft);
      clock.advance(const Duration(hours: 1));

      await repo.update(
        id,
        const ApplicationDraft(
          companyName: 'Arunika',
          positionTitle: 'Senior Flutter Developer',
          status: ApplicationStatus.screening,
        ),
      );

      final app = (await repo.getById(id))!;
      expect(app.positionTitle, 'Senior Flutter Developer');
      expect(app.workMode, isNull);
      expect(app.appliedAt, DateTime.utc(2026, 9, 26));
      expect(app.createdAt, isNot(app.updatedAt));
      expect(await repo.watchStatusHistory(id).first, hasLength(2));
    });

    test('does not add history when the status is unchanged', () async {
      final id = await repo.create(draft);
      await repo.update(id, draft);

      expect(await repo.watchStatusHistory(id).first, hasLength(1));
    });

    test('throws NotFoundException for a missing application', () {
      expect(repo.update(42, draft), throwsA(isA<NotFoundException>()));
    });
  });

  test('watchAll emits changes, most recently updated first', () async {
    // A single long-lived subscription, as a StreamProvider would hold.
    final emissions = <List<String>>[];
    final subscription = repo
        .watchAll()
        .map((apps) => apps.map((a) => a.companyName).toList())
        .listen(emissions.add);
    addTearDown(subscription.cancel);

    Future<void> expectLatest(List<String> expected) async {
      for (var i = 0; i < 100; i++) {
        if (emissions.isNotEmpty && listEquals(emissions.last, expected)) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      fail('Expected latest emission $expected, got $emissions');
    }

    await expectLatest([]);

    final first = await repo.create(
      const ApplicationDraft(companyName: 'First', positionTitle: 'Dev'),
    );
    await expectLatest(['First']);

    clock.advance(const Duration(minutes: 1));
    await repo.create(
      const ApplicationDraft(companyName: 'Second', positionTitle: 'Dev'),
    );
    await expectLatest(['Second', 'First']);

    clock.advance(const Duration(minutes: 1));
    await repo.changeStatus(first, ApplicationStatus.applied);
    await expectLatest(['First', 'Second']);
  });

  test('delete cascades to all child records', () async {
    final id = await repo.create(draft);
    final interviewId = await InterviewRepository(db).create(
      id,
      InterviewDraft(
        title: 'HR Interview',
        format: InterviewFormat.video,
        scheduledAt: DateTime(2026, 10, 1, 9),
      ),
    );
    await ChecklistRepository(db)
        .add(id, 'Research the company', interviewId: interviewId);
    await NoteRepository(db).add(id, 'Referred by a friend');

    await repo.delete(id);

    expect(await db.select(db.applications).get(), isEmpty);
    expect(await db.select(db.statusHistory).get(), isEmpty);
    expect(await db.select(db.interviews).get(), isEmpty);
    expect(await db.select(db.checklistItems).get(), isEmpty);
    expect(await db.select(db.notes).get(), isEmpty);
  });
}
