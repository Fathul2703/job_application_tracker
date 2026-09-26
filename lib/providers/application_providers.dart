import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/status_change.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

/// All applications, most recently updated first. Shared by the
/// Applications list, Dashboard and Analytics.
final applicationsProvider = StreamProvider<List<Application>>(
  (ref) => ref.watch(applicationRepositoryProvider).watchAll(),
);

/// One application, or `null` once it no longer exists.
final applicationProvider = StreamProvider.autoDispose
    .family<Application?, int>(
      (ref, id) => ref.watch(applicationRepositoryProvider).watchById(id),
    );

/// Status history of one application, oldest first.
final statusHistoryProvider = StreamProvider.autoDispose
    .family<List<StatusChange>, int>(
      (ref, id) =>
          ref.watch(applicationRepositoryProvider).watchStatusHistory(id),
    );
