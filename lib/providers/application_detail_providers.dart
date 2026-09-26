import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/domain/models/checklist_item.dart';
import 'package:job_application_tracker/domain/models/interview.dart';
import 'package:job_application_tracker/domain/models/note.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

/// Interviews of one application, earliest first.
final interviewsProvider = StreamProvider.autoDispose
    .family<List<Interview>, int>(
      (ref, applicationId) => ref
          .watch(interviewRepositoryProvider)
          .watchForApplication(applicationId),
    );

/// One interview, or `null` once it no longer exists.
final interviewProvider = StreamProvider.autoDispose.family<Interview?, int>(
  (ref, id) => ref.watch(interviewRepositoryProvider).watchById(id),
);

/// Checklist of one application in display order.
final checklistProvider = StreamProvider.autoDispose
    .family<List<ChecklistItem>, int>(
      (ref, applicationId) => ref
          .watch(checklistRepositoryProvider)
          .watchForApplication(applicationId),
    );

/// Notes of one application, newest first.
final notesProvider = StreamProvider.autoDispose.family<List<Note>, int>(
  (ref, applicationId) =>
      ref.watch(noteRepositoryProvider).watchForApplication(applicationId),
);
