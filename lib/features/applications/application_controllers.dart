import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

// Controllers turn UI intents into repository calls. Their state is the
// status of the last action (loading / error), which screens use to show
// progress and error messages. Methods report success so screens can
// navigate afterwards.

/// Saves the create/edit application form.
final applicationFormControllerProvider =
    AsyncNotifierProvider.autoDispose<ApplicationFormController, void>(
      ApplicationFormController.new,
    );

class ApplicationFormController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Creates a new application, or updates [id] when given.
  /// Returns the application id on success, `null` on failure.
  Future<int?> save(ApplicationDraft draft, {int? id}) async {
    final repository = ref.read(applicationRepositoryProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      if (id == null) return repository.create(draft);
      await repository.update(id, draft);
      return id;
    });
    if (!ref.mounted) return result.value;
    state = result.hasError
        ? AsyncError(result.error!, result.stackTrace!)
        : const AsyncData(null);
    return result.value;
  }
}

/// Status changes and deletion from the detail screen.
final applicationDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<ApplicationDetailController, void, int>(
      ApplicationDetailController.new,
    );

class ApplicationDetailController extends AsyncNotifier<void> {
  ApplicationDetailController(this.applicationId);

  final int applicationId;

  @override
  FutureOr<void> build() {}

  Future<bool> changeStatus(ApplicationStatus status) => _run(
    () => ref
        .read(applicationRepositoryProvider)
        .changeStatus(applicationId, status),
  );

  Future<bool> delete() =>
      _run(() => ref.read(applicationRepositoryProvider).delete(applicationId));

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(action);
    if (ref.mounted) state = result;
    return !result.hasError;
  }
}

/// Loads fictional demo data into an empty database (debug builds only).
final demoDataControllerProvider =
    AsyncNotifierProvider.autoDispose<DemoDataController, void>(
      DemoDataController.new,
    );

class DemoDataController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> load() async {
    final seeder = ref.read(demoDataSeederProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(seeder.seedIfEmpty);
    if (ref.mounted) state = result.hasError ? result : const AsyncData(null);
  }
}
