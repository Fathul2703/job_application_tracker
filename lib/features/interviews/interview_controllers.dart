import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/domain/models/interview.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

/// Saves and deletes interviews from the interview form.
final interviewFormControllerProvider =
    AsyncNotifierProvider.autoDispose<InterviewFormController, void>(
      InterviewFormController.new,
    );

class InterviewFormController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Creates an interview for [applicationId], or updates [id] when given.
  /// Returns the interview id on success, `null` on failure.
  Future<int?> save(int applicationId, InterviewDraft draft, {int? id}) async {
    final repository = ref.read(interviewRepositoryProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      if (id == null) return repository.create(applicationId, draft);
      await repository.update(id, draft);
      return id;
    });
    if (!ref.mounted) return result.value;
    state = result.hasError
        ? AsyncError(result.error!, result.stackTrace!)
        : const AsyncData(null);
    return result.value;
  }

  Future<bool> delete(int id) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(interviewRepositoryProvider).delete(id),
    );
    if (ref.mounted) state = result;
    return !result.hasError;
  }
}
