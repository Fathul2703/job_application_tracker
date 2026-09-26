import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/repositories/checklist_repository.dart';
import 'package:job_application_tracker/data/repositories/interview_repository.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/interview.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late InterviewRepository repo;
  late int applicationId;

  InterviewDraft draftAt(DateTime scheduledAt, {String title = 'Interview'}) =>
      InterviewDraft(
        title: title,
        format: InterviewFormat.video,
        scheduledAt: scheduledAt,
      );

  setUp(() async {
    db = createTestDatabase();
    clock = FakeClock.standard();
    repo = InterviewRepository(db, clock: clock.call);
    applicationId = await ApplicationRepository(
      db,
    ).create(const ApplicationDraft(companyName: 'Acme', positionTitle: 'Dev'));
  });

  test('creates an interview with UTC schedule and pending outcome', () async {
    final scheduled = DateTime(2026, 10, 1, 9, 30);
    final id = await repo.create(
      applicationId,
      InterviewDraft(
        title: ' HR Interview ',
        format: InterviewFormat.phone,
        scheduledAt: scheduled,
        location: ' ',
        durationMinutes: 45,
      ),
    );

    final interview = (await repo.getById(id))!;
    expect(interview.title, 'HR Interview');
    expect(interview.scheduledAt, scheduled.toUtc());
    expect(interview.scheduledAt.isUtc, isTrue);
    expect(interview.location, isNull);
    expect(interview.outcome, InterviewOutcome.pending);
  });

  test('lists interviews of an application in schedule order', () async {
    await repo.create(
      applicationId,
      draftAt(DateTime(2026, 10, 9), title: 'B'),
    );
    await repo.create(
      applicationId,
      draftAt(DateTime(2026, 10, 2), title: 'A'),
    );

    final titles = (await repo.watchForApplication(applicationId).first).map(
      (i) => i.title,
    );
    expect(titles, ['A', 'B']);
  });

  test('update changes fields and updatedAt', () async {
    final id = await repo.create(applicationId, draftAt(DateTime(2026, 10, 2)));
    clock.advance(const Duration(hours: 3));

    final current = (await repo.getById(id))!;
    await repo.update(
      id,
      InterviewDraft(
        title: current.title,
        format: current.format,
        scheduledAt: current.scheduledAt,
        outcome: InterviewOutcome.passed,
        summary: 'Went well',
      ),
    );

    final updated = (await repo.getById(id))!;
    expect(updated.outcome, InterviewOutcome.passed);
    expect(updated.summary, 'Went well');
    expect(updated.updatedAt, clock.now.toUtc());
    expect(updated.createdAt, current.createdAt);
  });

  test('validates drafts', () {
    expect(
      repo.create(
        applicationId,
        InterviewDraft(
          title: '',
          format: InterviewFormat.video,
          scheduledAt: DateTime(2026, 10, 2),
          durationMinutes: 0,
        ),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('update throws NotFoundException for a missing interview', () {
    expect(
      repo.update(99, draftAt(DateTime(2026, 10, 2))),
      throwsA(isA<NotFoundException>()),
    );
  });

  test('delete removes checklist items linked to the interview', () async {
    final id = await repo.create(applicationId, draftAt(DateTime(2026, 10, 2)));
    final checklist = ChecklistRepository(db);
    await checklist.add(applicationId, 'Linked', interviewId: id);
    await checklist.add(applicationId, 'General');

    await repo.delete(id);

    final remaining = await checklist.watchForApplication(applicationId).first;
    expect(remaining.map((i) => i.title), ['General']);
  });
}
