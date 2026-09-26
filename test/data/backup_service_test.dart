import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/backup/backup_service.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/seed/demo_data_seeder.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/domain/models/application.dart';

import '../helpers/test_database.dart';

Future<Map<String, List<Object?>>> _dump(AppDatabase db) async => {
  'applications': await db.select(db.applications).get(),
  'statusHistory': await db.select(db.statusHistory).get(),
  'interviews': await db.select(db.interviews).get(),
  'checklistItems': await db.select(db.checklistItems).get(),
  'notes': await db.select(db.notes).get(),
};

void main() {
  late AppDatabase db;
  late BackupService backup;

  setUp(() async {
    db = createTestDatabase();
    backup = BackupService(db, clock: FakeClock.standard().call);
    await DemoDataSeeder(db, clock: FakeClock.standard().call).seed();
  });

  test('export → clear → restore reproduces every row exactly', () async {
    final before = await _dump(db);
    final json = await backup.exportJson();

    await backup.clearAll();
    expect(await backup.applicationCount(), 0);

    await backup.restore(backup.parse(json));
    expect(await _dump(db), before);
  });

  test('restored data keeps working with new records', () async {
    await backup.restore(backup.parse(await backup.exportJson()));

    final id = await ApplicationRepository(db).create(
      const ApplicationDraft(companyName: 'New Co', positionTitle: 'Dev'),
    );
    expect(id, greaterThan(13)); // No id collision after restoring ids.
  });

  test('export format is versioned and uses readable dates', () async {
    final json = jsonDecode(await backup.exportJson()) as Map<String, Object?>;
    expect(json['format'], BackupService.format);
    expect(json['version'], BackupService.version);
    expect(json['exportedAt'], '2026-09-26T03:30:00.000Z');

    final first = (json['applications']! as List).first as Map;
    expect(first['appliedAt'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    expect(first['createdAt'], endsWith('Z'));
    expect(first['status'], isA<String>());
  });

  group('parse rejects unusable files', () {
    void expectRejected(String text, String message) => expect(
      () => backup.parse(text),
      throwsA(
        isA<BackupFormatException>().having(
          (e) => e.message,
          'message',
          contains(message),
        ),
      ),
    );

    test('not JSON', () => expectRejected('hello', 'not a valid backup'));

    test('other JSON', () {
      expectRejected('{"foo": 1}', 'not a Job Tracker backup');
    });

    test('newer version', () {
      expectRejected(
        '{"format": "${BackupService.format}", "version": 99}',
        'newer version',
      );
    });

    test('damaged field names the location', () async {
      final json =
          jsonDecode(await backup.exportJson()) as Map<String, Object?>;
      ((json['applications']! as List).first as Map)['status'] = 'hired';
      expectRejected(jsonEncode(json), 'applications[0].status');
    });
  });

  test('inconsistent data leaves the database untouched', () async {
    final before = await _dump(db);
    final json = jsonDecode(await backup.exportJson()) as Map<String, Object?>;
    // A note pointing at an application that isn't in the backup.
    ((json['notes']! as List).first as Map)['applicationId'] = 999;

    final snapshot = backup.parse(jsonEncode(json));
    await expectLater(
      backup.restore(snapshot),
      throwsA(isA<BackupFormatException>()),
    );
    expect(await _dump(db), before);
  });

  group('CSV', () {
    test('has a header and one row per application', () async {
      final csv = await backup.exportApplicationsCsv();
      final lines = csv.trimRight().split('\r\n');

      expect(lines.first, startsWith('Company,Position,Status,'));
      expect(lines, hasLength(1 + 13));
      expect(csv, contains('Rimba Logistics,Backend Developer,Interview,'));
    });

    test('quotes fields with commas, quotes and line breaks', () {
      expect(BackupService.csvField('plain'), 'plain');
      expect(BackupService.csvField('a, b'), '"a, b"');
      expect(BackupService.csvField('say "hi"'), '"say ""hi"""');
      expect(BackupService.csvField('two\nlines'), '"two\nlines"');
    });
  });
}
