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
  late ChecklistRepository repo;
  late int applicationId;

  Future<List<String>> titles() async =>
      (await repo.watchForApplication(applicationId).first)
          .map((i) => i.title)
          .toList();

  setUp(() async {
    db = createTestDatabase();
    clock = FakeClock.standard();
    repo = ChecklistRepository(db, clock: clock.call);
    applicationId = await ApplicationRepository(
      db,
    ).create(const ApplicationDraft(companyName: 'Acme', positionTitle: 'Dev'));
  });

  test('appends items with increasing positions', () async {
    await repo.add(applicationId, ' First ');
    await repo.add(applicationId, 'Second');
    await repo.add(applicationId, 'Third');

    final items = await repo.watchForApplication(applicationId).first;
    expect(items.map((i) => i.title), ['First', 'Second', 'Third']);
    expect(items.map((i) => i.position), [0, 1, 2]);
    expect(items.every((i) => !i.isDone && i.completedAt == null), isTrue);
  });

  test('positions are per application', () async {
    final otherApplication = await ApplicationRepository(db).create(
      const ApplicationDraft(companyName: 'Other', positionTitle: 'Dev'),
    );
    await repo.add(otherApplication, 'Other item');
    await repo.add(applicationId, 'Mine');

    final mine = await repo.watchForApplication(applicationId).first;
    expect(mine.single.position, 0);
  });

  test('setDone toggles completion and completedAt', () async {
    final id = await repo.add(applicationId, 'Task');

    await repo.setDone(id, isDone: true);
    var item = (await repo.watchForApplication(applicationId).first).single;
    expect(item.isDone, isTrue);
    expect(item.completedAt, clock.now.toUtc());

    await repo.setDone(id, isDone: false);
    item = (await repo.watchForApplication(applicationId).first).single;
    expect(item.isDone, isFalse);
    expect(item.completedAt, isNull);
  });

  test('rename trims and validates', () async {
    final id = await repo.add(applicationId, 'Task');

    await repo.rename(id, '  Renamed ');
    expect(await titles(), ['Renamed']);

    expect(repo.rename(id, '   '), throwsA(isA<ValidationException>()));
    expect(repo.rename(99, 'x'), throwsA(isA<NotFoundException>()));
  });

  test('rejects empty titles on add', () {
    expect(repo.add(applicationId, ''), throwsA(isA<ValidationException>()));
  });

  test('reorder persists the new order', () async {
    final a = await repo.add(applicationId, 'A');
    final b = await repo.add(applicationId, 'B');
    final c = await repo.add(applicationId, 'C');

    await repo.reorder(applicationId, [c, a, b]);

    expect(await titles(), ['C', 'A', 'B']);
  });

  test('reorder rejects an incomplete id list', () async {
    final a = await repo.add(applicationId, 'A');
    await repo.add(applicationId, 'B');

    expect(repo.reorder(applicationId, [a]), throwsArgumentError);
    expect(await titles(), ['A', 'B']);
  });

  test('rejects an interview from another application', () async {
    final otherApplication = await ApplicationRepository(db).create(
      const ApplicationDraft(companyName: 'Other', positionTitle: 'Dev'),
    );
    final foreignInterview = await InterviewRepository(db).create(
      otherApplication,
      InterviewDraft(
        title: 'HR',
        format: InterviewFormat.phone,
        scheduledAt: DateTime(2026, 10, 1),
      ),
    );

    expect(
      repo.add(applicationId, 'Prep', interviewId: foreignInterview),
      throwsArgumentError,
    );
  });

  test('delete removes one item', () async {
    final a = await repo.add(applicationId, 'A');
    await repo.add(applicationId, 'B');

    await repo.delete(a);

    expect(await titles(), ['B']);
  });

  group('linkToInterview', () {
    late int interviewId;

    setUp(() async {
      interviewId = await InterviewRepository(db).create(
        applicationId,
        InterviewDraft(
          title: 'HR',
          format: InterviewFormat.video,
          scheduledAt: DateTime(2026, 10, 1),
        ),
      );
    });

    test('links and unlinks an item', () async {
      final id = await repo.add(applicationId, 'Prep');

      await repo.linkToInterview(id, interviewId);
      var item = (await repo.watchForApplication(applicationId).first).single;
      expect(item.interviewId, interviewId);

      await repo.linkToInterview(id, null);
      item = (await repo.watchForApplication(applicationId).first).single;
      expect(item.interviewId, isNull);
    });

    test('rejects an interview from another application', () async {
      final other = await ApplicationRepository(db).create(
        const ApplicationDraft(companyName: 'Other', positionTitle: 'Dev'),
      );
      final id = await repo.add(other, 'Prep');

      expect(repo.linkToInterview(id, interviewId), throwsArgumentError);
    });

    test('throws NotFoundException for a missing item', () {
      expect(
        repo.linkToInterview(99, interviewId),
        throwsA(isA<NotFoundException>()),
      );
    });
  });
}
