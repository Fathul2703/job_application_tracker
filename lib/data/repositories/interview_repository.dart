import 'package:drift/drift.dart';
import 'package:job_application_tracker/core/utils/clock.dart';
import 'package:job_application_tracker/core/utils/strings.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/domain/models/interview.dart';

class InterviewRepository {
  InterviewRepository(this._db, {this._clock = DateTime.now});

  final AppDatabase _db;
  final Clock _clock;

  $InterviewsTable get _table => _db.interviews;

  /// Interviews of one application, earliest first.
  Stream<List<Interview>> watchForApplication(int applicationId) {
    final query = _db.select(_table)
      ..where((t) => t.applicationId.equals(applicationId))
      ..orderBy([
        (t) => OrderingTerm.asc(t.scheduledAt),
        (t) => OrderingTerm.asc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  /// One interview, or `null` once it no longer exists.
  Stream<Interview?> watchById(int id) {
    final query = _db.select(_table)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toModel(row),
    );
  }

  Future<Interview?> getById(int id) async {
    final row = await (_db.select(
      _table,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  /// Returns the new id. Throws [ValidationException] for invalid drafts.
  Future<int> create(int applicationId, InterviewDraft draft) async {
    _ensureValid(draft);
    final timestamp = _clock().toUtc();
    return _db
        .into(_table)
        .insert(
          _companion(draft).copyWith(
            applicationId: Value(applicationId),
            createdAt: Value(timestamp),
            updatedAt: Value(timestamp),
          ),
        );
  }

  Future<void> update(int id, InterviewDraft draft) async {
    _ensureValid(draft);
    final updated = await (_db.update(_table)..where((t) => t.id.equals(id)))
        .write(_companion(draft).copyWith(updatedAt: Value(_clock().toUtc())));
    if (updated == 0) throw NotFoundException('Interview', id);
  }

  /// Also deletes checklist items linked to this interview.
  Future<void> delete(int id) =>
      (_db.delete(_table)..where((t) => t.id.equals(id))).go();

  void _ensureValid(InterviewDraft draft) {
    final problems = draft.validate();
    if (problems.isNotEmpty) throw ValidationException(problems);
  }

  static InterviewsCompanion _companion(InterviewDraft draft) =>
      InterviewsCompanion(
        title: Value(draft.title.trim()),
        format: Value(draft.format),
        scheduledAt: Value(draft.scheduledAt.toUtc()),
        durationMinutes: Value(draft.durationMinutes),
        location: Value(draft.location.trimmedOrNull),
        interviewer: Value(draft.interviewer.trimmedOrNull),
        outcome: Value(draft.outcome),
        summary: Value(draft.summary.trimmedOrNull),
      );

  static Interview _toModel(InterviewRow row) => Interview(
    id: row.id,
    applicationId: row.applicationId,
    title: row.title,
    format: row.format,
    scheduledAt: row.scheduledAt,
    durationMinutes: row.durationMinutes,
    location: row.location,
    interviewer: row.interviewer,
    outcome: row.outcome,
    summary: row.summary,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
