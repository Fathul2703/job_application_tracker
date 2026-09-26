import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/repositories/note_repository.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/domain/models/application.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late NoteRepository repo;
  late int applicationId;

  setUp(() async {
    db = createTestDatabase();
    clock = FakeClock.standard();
    repo = NoteRepository(db, clock: clock.call);
    applicationId = await ApplicationRepository(
      db,
    ).create(const ApplicationDraft(companyName: 'Acme', positionTitle: 'Dev'));
  });

  test('lists notes newest first', () async {
    await repo.add(applicationId, 'Older');
    clock.advance(const Duration(minutes: 5));
    await repo.add(applicationId, ' Newer ');

    final notes = await repo.watchForApplication(applicationId).first;
    expect(notes.map((n) => n.content), ['Newer', 'Older']);
  });

  test('update changes content and updatedAt only', () async {
    final id = await repo.add(applicationId, 'Draft');
    final created = clock.now.toUtc();
    clock.advance(const Duration(hours: 1));

    await repo.update(id, 'Final');

    final note = (await repo.watchForApplication(applicationId).first).single;
    expect(note.content, 'Final');
    expect(note.createdAt, created);
    expect(note.updatedAt, clock.now.toUtc());
  });

  test('rejects empty content', () async {
    final id = await repo.add(applicationId, 'Note');

    expect(repo.add(applicationId, '  '), throwsA(isA<ValidationException>()));
    expect(repo.update(id, ''), throwsA(isA<ValidationException>()));
  });

  test('update throws NotFoundException for a missing note', () {
    expect(repo.update(99, 'x'), throwsA(isA<NotFoundException>()));
  });

  test('delete removes the note', () async {
    final id = await repo.add(applicationId, 'Note');
    await repo.delete(id);

    expect(await repo.watchForApplication(applicationId).first, isEmpty);
  });
}
