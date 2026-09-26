import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

/// Checklist actions for one application. State reflects the last action,
/// so screens can show errors.
final checklistControllerProvider = AsyncNotifierProvider.autoDispose
    .family<ChecklistController, void, int>(ChecklistController.new);

class ChecklistController extends AsyncNotifier<void> {
  ChecklistController(this.applicationId);

  final int applicationId;

  @override
  FutureOr<void> build() {}

  Future<bool> add(String title, {int? interviewId}) => _run(
    () => ref
        .read(checklistRepositoryProvider)
        .add(applicationId, title, interviewId: interviewId),
  );

  Future<bool> setDone(int id, {required bool isDone}) => _run(
    () => ref.read(checklistRepositoryProvider).setDone(id, isDone: isDone),
  );

  Future<bool> rename(int id, String title) =>
      _run(() => ref.read(checklistRepositoryProvider).rename(id, title));

  Future<bool> linkToInterview(int id, int? interviewId) => _run(
    () =>
        ref.read(checklistRepositoryProvider).linkToInterview(id, interviewId),
  );

  Future<bool> delete(int id) =>
      _run(() => ref.read(checklistRepositoryProvider).delete(id));

  Future<bool> reorder(List<int> orderedIds) => _run(
    () => ref
        .read(checklistRepositoryProvider)
        .reorder(applicationId, orderedIds),
  );

  Future<bool> _run(Future<Object?> Function() action) async {
    final result = await AsyncValue.guard(action);
    if (ref.mounted) {
      state = result.hasError
          ? AsyncError(result.error!, result.stackTrace!)
          : const AsyncData(null);
    }
    return !result.hasError;
  }
}

/// Note actions for one application.
final notesControllerProvider = AsyncNotifierProvider.autoDispose
    .family<NotesController, void, int>(NotesController.new);

class NotesController extends AsyncNotifier<void> {
  NotesController(this.applicationId);

  final int applicationId;

  @override
  FutureOr<void> build() {}

  Future<bool> add(String content) =>
      _run(() => ref.read(noteRepositoryProvider).add(applicationId, content));

  Future<bool> edit(int id, String content) =>
      _run(() => ref.read(noteRepositoryProvider).update(id, content));

  Future<bool> delete(int id) =>
      _run(() => ref.read(noteRepositoryProvider).delete(id));

  Future<bool> _run(Future<Object?> Function() action) async {
    final result = await AsyncValue.guard(action);
    if (ref.mounted) {
      state = result.hasError
          ? AsyncError(result.error!, result.stackTrace!)
          : const AsyncData(null);
    }
    return !result.hasError;
  }
}
