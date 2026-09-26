import 'dart:async';
import 'dart:ui' show Rect;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/data/backup/backup_service.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

/// Backup, restore, CSV export and "delete all" for the Settings screen.
/// State is the last action's loading/error; methods report success.
final dataControllerProvider =
    AsyncNotifierProvider.autoDispose<DataController, void>(DataController.new);

class DataController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  BackupService get _backup => ref.read(backupServiceProvider);

  /// `2026-09-26` from the injected clock, for file names.
  String get _today {
    final now = ref.read(clockProvider)();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)}';
  }

  Future<bool> exportBackup({Rect? origin}) => _run(() async {
    await ref
        .read(fileExchangeProvider)
        .shareTextFile(
          fileName: 'job-tracker-backup-$_today.json',
          content: await _backup.exportJson(),
          mimeType: 'application/json',
          origin: origin,
        );
  });

  Future<bool> exportCsv({Rect? origin}) => _run(() async {
    await ref
        .read(fileExchangeProvider)
        .shareTextFile(
          fileName: 'job-tracker-applications-$_today.csv',
          content: await _backup.exportApplicationsCsv(),
          mimeType: 'text/csv',
          origin: origin,
        );
  });

  /// Lets the user pick a backup and validates it. Returns `null` when the
  /// picker was dismissed or the file was invalid (the error is in state).
  Future<BackupSnapshot?> pickBackup() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final String? text;
      try {
        text = await ref
            .read(fileExchangeProvider)
            .pickTextFile(extensions: const ['json']);
      } on FormatException {
        throw const BackupFormatException('This file is not a valid backup.');
      }
      return text == null ? null : _backup.parse(text);
    });
    if (ref.mounted) {
      state = result.hasError
          ? AsyncError(result.error!, result.stackTrace!)
          : const AsyncData(null);
    }
    return result.value;
  }

  Future<bool> restore(BackupSnapshot snapshot) =>
      _run(() => _backup.restore(snapshot));

  Future<bool> deleteAll() => _run(_backup.clearAll);

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (ref.mounted) state = result;
    return !result.hasError;
  }
}
