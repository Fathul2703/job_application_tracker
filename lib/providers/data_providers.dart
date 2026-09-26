import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/utils/clock.dart';
import 'package:job_application_tracker/data/backup/backup_service.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/files/file_exchange.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/repositories/checklist_repository.dart';
import 'package:job_application_tracker/data/repositories/interview_repository.dart';
import 'package:job_application_tracker/data/repositories/note_repository.dart';
import 'package:job_application_tracker/data/seed/demo_data_seeder.dart';

/// Current time. Override in tests for deterministic timestamps.
final clockProvider = Provider<Clock>((ref) => DateTime.now);

/// The app's single database connection. Override with
/// `AppDatabase.forTesting(NativeDatabase.memory())` in tests.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final applicationRepositoryProvider = Provider<ApplicationRepository>(
  (ref) => ApplicationRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final interviewRepositoryProvider = Provider<InterviewRepository>(
  (ref) => InterviewRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final checklistRepositoryProvider = Provider<ChecklistRepository>(
  (ref) => ChecklistRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final demoDataSeederProvider = Provider<DemoDataSeeder>(
  (ref) => DemoDataSeeder(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepository(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    ref.watch(appDatabaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// Share sheet and file picker. Overridden with a fake in tests.
final fileExchangeProvider = Provider<FileExchange>(
  (ref) => const PlatformFileExchange(),
);
