import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';

/// Verifies the native SQLite library and the on-device database file work
/// on a real iOS/Android target.
///
/// Only touches the record it creates, so it is safe on a device that
/// already has data.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens the on-device database and round-trips data', (_) async {
    final db = AppDatabase();
    addTearDown(db.close);

    final version = await db
        .customSelect('SELECT sqlite_version() AS version')
        .getSingle();
    debugPrint('SQLite ${version.read<String>('version')}');

    final foreignKeys = await db
        .customSelect('PRAGMA foreign_keys')
        .getSingle();
    expect(foreignKeys.read<int>('foreign_keys'), 1);

    final repo = ApplicationRepository(db);
    final id = await repo.create(
      const ApplicationDraft(
        companyName: 'Integration Test Co',
        positionTitle: 'Smoke Test',
        status: ApplicationStatus.applied,
      ),
    );
    addTearDown(() => repo.delete(id));

    final app = await repo.getById(id);
    expect(app?.status, ApplicationStatus.applied);
    expect(app?.appliedAt, isNotNull);
    expect(await repo.watchStatusHistory(id).first, hasLength(1));
  });
}
