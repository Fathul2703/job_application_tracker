import 'package:drift/drift.dart';
import 'package:job_application_tracker/core/utils/clock.dart';
import 'package:job_application_tracker/core/utils/date_only.dart';
import 'package:job_application_tracker/core/utils/strings.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/application_query.dart';
import 'package:job_application_tracker/domain/models/status_change.dart';

/// Reads and writes applications and their status history.
///
/// Invariants enforced here (not in the UI):
/// - every status change is recorded in `status_history` in the same
///   transaction as the change itself;
/// - `appliedAt` is filled with today's date when an application has a
///   non-`saved` status and no applied date yet;
/// - text is trimmed, empty optional text is stored as `NULL`;
/// - timestamps are UTC, dates are date-only.
class ApplicationRepository {
  ApplicationRepository(this._db, {this._clock = DateTime.now});

  final AppDatabase _db;
  final Clock _clock;

  $ApplicationsTable get _table => _db.applications;

  /// Applications matching [query], in its sort order. The default query
  /// returns everything, most recently updated first.
  Stream<List<Application>> watchAll({
    ApplicationQuery query = const ApplicationQuery(),
  }) {
    final select = _db.select(_table);

    for (final term in query.searchTerms) {
      final pattern = '%${_escapeLike(term)}%';
      select.where(
        (t) =>
            t.companyName.like(pattern, escapeChar: _likeEscape) |
            t.positionTitle.like(pattern, escapeChar: _likeEscape) |
            t.location.like(pattern, escapeChar: _likeEscape),
      );
    }
    if (query.statuses.isNotEmpty) {
      select.where((t) => t.status.isInValues(query.statuses));
    }
    if (query.workModes.isNotEmpty) {
      select.where((t) => t.workMode.isInValues(query.workModes));
    }
    if (query.employmentTypes.isNotEmpty) {
      select.where((t) => t.employmentType.isInValues(query.employmentTypes));
    }

    select.orderBy([
      ...switch (query.sort) {
        ApplicationSort.recentlyUpdated =>
          <OrderClauseGenerator<$ApplicationsTable>>[],
        ApplicationSort.appliedDate => [
          (t) => OrderingTerm.desc(t.appliedAt, nulls: NullsOrder.last),
        ],
        ApplicationSort.deadline => [
          (t) => OrderingTerm.asc(t.deadlineAt, nulls: NullsOrder.last),
        ],
        ApplicationSort.company => [
          (t) => OrderingTerm.asc(t.companyName.collate(Collate.noCase)),
          (t) => OrderingTerm.asc(t.positionTitle.collate(Collate.noCase)),
        ],
      },
      // Stable tie-breakers for every sort.
      (t) => OrderingTerm.desc(t.updatedAt),
      (t) => OrderingTerm.desc(t.id),
    ]);

    return select.watch().map((rows) => rows.map(_toModel).toList());
  }

  static const _likeEscape = r'\';

  /// Makes `%`, `_` and the escape character match literally in LIKE.
  static String _escapeLike(String term) =>
      term.replaceAllMapped(RegExp(r'[%_\\]'), (m) => '\\${m[0]}');

  Stream<Application?> watchById(int id) {
    final query = _db.select(_table)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : _toModel(row),
    );
  }

  Future<Application?> getById(int id) async {
    final row = await (_db.select(
      _table,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  /// Status history of one application, oldest first.
  Stream<List<StatusChange>> watchStatusHistory(int applicationId) {
    final query = _db.select(_db.statusHistory)
      ..where((t) => t.applicationId.equals(applicationId))
      ..orderBy([
        (t) => OrderingTerm.asc(t.changedAt),
        (t) => OrderingTerm.asc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toStatusChange).toList());
  }

  /// Creates an application and records its initial status.
  /// Returns the new id. Throws [ValidationException] for invalid drafts.
  Future<int> create(ApplicationDraft draft) async {
    _ensureValid(draft);
    return _db.transaction(() async {
      final now = _clock();
      final timestamp = now.toUtc();
      final id = await _db
          .into(_table)
          .insert(
            _companion(draft, now).copyWith(
              createdAt: Value(timestamp),
              updatedAt: Value(timestamp),
            ),
          );
      await _recordStatus(id, from: null, to: draft.status, at: timestamp);
      return id;
    });
  }

  /// Replaces all editable fields. A status change is recorded in history.
  Future<void> update(int id, ApplicationDraft draft) async {
    _ensureValid(draft);
    return _db.transaction(() async {
      final current = await _requireRow(id);
      final now = _clock();
      final timestamp = now.toUtc();
      await (_db.update(_table)..where((t) => t.id.equals(id))).write(
        _companion(draft, now).copyWith(updatedAt: Value(timestamp)),
      );
      if (current.status != draft.status) {
        await _recordStatus(
          id,
          from: current.status,
          to: draft.status,
          at: timestamp,
        );
      }
    });
  }

  /// Moves an application to [status]. Does nothing if it already has it.
  Future<void> changeStatus(int id, ApplicationStatus status) {
    return _db.transaction(() async {
      final current = await _requireRow(id);
      if (current.status == status) return;

      final now = _clock();
      final timestamp = now.toUtc();
      await (_db.update(_table)..where((t) => t.id.equals(id))).write(
        ApplicationsCompanion(
          status: Value(status),
          appliedAt: Value(_resolveAppliedAt(current.appliedAt, status, now)),
          updatedAt: Value(timestamp),
        ),
      );
      await _recordStatus(id, from: current.status, to: status, at: timestamp);
    });
  }

  /// Deletes an application together with its interviews, checklist items,
  /// notes and status history (via `ON DELETE CASCADE`).
  Future<void> delete(int id) =>
      (_db.delete(_table)..where((t) => t.id.equals(id))).go();

  // --- helpers ---------------------------------------------------------------

  void _ensureValid(ApplicationDraft draft) {
    final problems = draft.validate();
    if (problems.isNotEmpty) throw ValidationException(problems);
  }

  Future<ApplicationRow> _requireRow(int id) async {
    final row = await (_db.select(
      _table,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) throw NotFoundException('Application', id);
    return row;
  }

  ApplicationsCompanion _companion(ApplicationDraft draft, DateTime now) {
    return ApplicationsCompanion(
      companyName: Value(draft.companyName.trim()),
      positionTitle: Value(draft.positionTitle.trim()),
      location: Value(draft.location.trimmedOrNull),
      workMode: Value(draft.workMode),
      employmentType: Value(draft.employmentType),
      salaryMin: Value(draft.salaryMin),
      salaryMax: Value(draft.salaryMax),
      salaryCurrency: Value(draft.salaryCurrency),
      salaryPeriod: Value(draft.salaryPeriod),
      jobUrl: Value(draft.jobUrl.trimmedOrNull),
      status: Value(draft.status),
      appliedAt: Value(_resolveAppliedAt(draft.appliedAt, draft.status, now)),
      deadlineAt: Value(draft.deadlineAt?.toDateOnly()),
    );
  }

  /// Keeps an explicit applied date; otherwise uses today once the
  /// application has left `saved`.
  static DateTime? _resolveAppliedAt(
    DateTime? appliedAt,
    ApplicationStatus status,
    DateTime now,
  ) {
    if (appliedAt != null) return appliedAt.toDateOnly();
    if (status != ApplicationStatus.saved) return now.toDateOnly();
    return null;
  }

  Future<void> _recordStatus(
    int applicationId, {
    required ApplicationStatus? from,
    required ApplicationStatus to,
    required DateTime at,
  }) {
    return _db
        .into(_db.statusHistory)
        .insert(
          StatusHistoryCompanion.insert(
            applicationId: applicationId,
            fromStatus: Value(from),
            toStatus: to,
            changedAt: at,
          ),
        );
  }

  static Application _toModel(ApplicationRow row) => Application(
    id: row.id,
    companyName: row.companyName,
    positionTitle: row.positionTitle,
    location: row.location,
    workMode: row.workMode,
    employmentType: row.employmentType,
    salaryMin: row.salaryMin,
    salaryMax: row.salaryMax,
    salaryCurrency: row.salaryCurrency,
    salaryPeriod: row.salaryPeriod,
    jobUrl: row.jobUrl,
    status: row.status,
    appliedAt: row.appliedAt,
    deadlineAt: row.deadlineAt,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  static StatusChange _toStatusChange(StatusHistoryRow row) => StatusChange(
    id: row.id,
    applicationId: row.applicationId,
    fromStatus: row.fromStatus,
    toStatus: row.toStatus,
    changedAt: row.changedAt,
  );
}
