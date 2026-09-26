import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:job_application_tracker/core/utils/clock.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/errors.dart';

/// A parsed backup, validated and ready to restore.
class BackupSnapshot {
  const BackupSnapshot({
    required this.exportedAt,
    required this.applications,
    required this.statusHistory,
    required this.interviews,
    required this.checklistItems,
    required this.notes,
  });

  final DateTime exportedAt;
  final List<ApplicationsCompanion> applications;
  final List<StatusHistoryCompanion> statusHistory;
  final List<InterviewsCompanion> interviews;
  final List<ChecklistItemsCompanion> checklistItems;
  final List<NotesCompanion> notes;
}

/// Exports, restores and clears all app data.
///
/// The JSON format is explicit and versioned (not Drift's serializer):
/// date-only fields as `yyyy-MM-dd`, timestamps as UTC ISO-8601, enums by
/// name. Ids are kept so relations survive a round trip.
class BackupService {
  BackupService(this._db, {this._clock = DateTime.now});

  final AppDatabase _db;
  final Clock _clock;

  static const format = 'job-tracker-backup';
  static const version = 1;

  // --- export ----------------------------------------------------------------

  Future<String> exportJson() async {
    final applications = await _db.select(_db.applications).get();
    final history = await _db.select(_db.statusHistory).get();
    final interviews = await _db.select(_db.interviews).get();
    final checklist = await _db.select(_db.checklistItems).get();
    final notes = await _db.select(_db.notes).get();

    return const JsonEncoder.withIndent('  ').convert({
      'format': format,
      'version': version,
      'exportedAt': _timestamp(_clock()),
      'applications': [
        for (final a in applications)
          {
            'id': a.id,
            'companyName': a.companyName,
            'positionTitle': a.positionTitle,
            'location': a.location,
            'workMode': a.workMode?.name,
            'employmentType': a.employmentType?.name,
            'salaryMin': a.salaryMin,
            'salaryMax': a.salaryMax,
            'salaryCurrency': a.salaryCurrency,
            'salaryPeriod': a.salaryPeriod?.name,
            'jobUrl': a.jobUrl,
            'status': a.status.name,
            'appliedAt': _date(a.appliedAt),
            'deadlineAt': _date(a.deadlineAt),
            'createdAt': _timestamp(a.createdAt),
            'updatedAt': _timestamp(a.updatedAt),
          },
      ],
      'statusHistory': [
        for (final h in history)
          {
            'id': h.id,
            'applicationId': h.applicationId,
            'fromStatus': h.fromStatus?.name,
            'toStatus': h.toStatus.name,
            'changedAt': _timestamp(h.changedAt),
          },
      ],
      'interviews': [
        for (final i in interviews)
          {
            'id': i.id,
            'applicationId': i.applicationId,
            'title': i.title,
            'format': i.format.name,
            'scheduledAt': _timestamp(i.scheduledAt),
            'durationMinutes': i.durationMinutes,
            'location': i.location,
            'interviewer': i.interviewer,
            'outcome': i.outcome.name,
            'summary': i.summary,
            'createdAt': _timestamp(i.createdAt),
            'updatedAt': _timestamp(i.updatedAt),
          },
      ],
      'checklistItems': [
        for (final c in checklist)
          {
            'id': c.id,
            'applicationId': c.applicationId,
            'interviewId': c.interviewId,
            'title': c.title,
            'isDone': c.isDone,
            'position': c.position,
            'completedAt': _optionalTimestamp(c.completedAt),
            'createdAt': _timestamp(c.createdAt),
          },
      ],
      'notes': [
        for (final n in notes)
          {
            'id': n.id,
            'applicationId': n.applicationId,
            'content': n.content,
            'createdAt': _timestamp(n.createdAt),
            'updatedAt': _timestamp(n.updatedAt),
          },
      ],
    });
  }

  /// Applications only, for spreadsheets. Dates as `yyyy-MM-dd`.
  Future<String> exportApplicationsCsv() async {
    final applications =
        await (_db.select(_db.applications)..orderBy([
              (t) => OrderingTerm.asc(t.appliedAt, nulls: NullsOrder.last),
              (t) => OrderingTerm.asc(t.id),
            ]))
            .get();

    final rows = [
      [
        'Company',
        'Position',
        'Status',
        'Location',
        'Work mode',
        'Employment type',
        'Salary min',
        'Salary max',
        'Currency',
        'Salary period',
        'Applied',
        'Deadline',
        'Job URL',
        'Added',
        'Updated',
      ],
      for (final a in applications)
        [
          a.companyName,
          a.positionTitle,
          a.status.label,
          a.location ?? '',
          a.workMode?.label ?? '',
          a.employmentType?.label ?? '',
          a.salaryMin?.toString() ?? '',
          a.salaryMax?.toString() ?? '',
          a.salaryCurrency,
          a.salaryPeriod?.name ?? '',
          _date(a.appliedAt) ?? '',
          _date(a.deadlineAt) ?? '',
          a.jobUrl ?? '',
          _date(a.createdAt.toLocal()) ?? '',
          _date(a.updatedAt.toLocal()) ?? '',
        ],
    ];
    // CRLF line endings, as RFC 4180 and spreadsheet apps expect.
    return '${rows.map((row) => row.map(csvField).join(',')).join('\r\n')}\r\n';
  }

  /// Quotes a CSV field when it contains a comma, quote or line break.
  static String csvField(String value) {
    if (!value.contains(RegExp('[",\r\n]'))) return value;
    return '"${value.replaceAll('"', '""')}"';
  }

  // --- restore ---------------------------------------------------------------

  /// Parses and validates a backup file. Throws [BackupFormatException] with
  /// a user-facing message when the file isn't a usable backup.
  BackupSnapshot parse(String text) {
    final Object? root;
    try {
      root = jsonDecode(text);
    } on FormatException {
      throw const BackupFormatException('This file is not a valid backup.');
    }
    if (root is! Map<String, Object?> || root['format'] != format) {
      throw const BackupFormatException(
        'This file is not a Job Tracker backup.',
      );
    }
    final fileVersion = root['version'];
    if (fileVersion is! int || fileVersion > version) {
      throw const BackupFormatException(
        'This backup was made by a newer version of Job Tracker.',
      );
    }

    final r = _Reader(root, 'backup');
    return BackupSnapshot(
      exportedAt: r.timestamp('exportedAt'),
      applications: [
        for (final a in r.records('applications'))
          ApplicationsCompanion.insert(
            id: Value(a.integer('id')),
            companyName: a.string('companyName'),
            positionTitle: a.string('positionTitle'),
            location: Value(a.optionalString('location')),
            workMode: Value(a.optionalEnum('workMode', WorkMode.values)),
            employmentType: Value(
              a.optionalEnum('employmentType', EmploymentType.values),
            ),
            salaryMin: Value(a.optionalInteger('salaryMin')),
            salaryMax: Value(a.optionalInteger('salaryMax')),
            salaryCurrency: Value(a.string('salaryCurrency')),
            salaryPeriod: Value(
              a.optionalEnum('salaryPeriod', SalaryPeriod.values),
            ),
            jobUrl: Value(a.optionalString('jobUrl')),
            status: Value(a.enumValue('status', ApplicationStatus.values)),
            appliedAt: Value(a.optionalDate('appliedAt')),
            deadlineAt: Value(a.optionalDate('deadlineAt')),
            createdAt: a.timestamp('createdAt'),
            updatedAt: a.timestamp('updatedAt'),
          ),
      ],
      statusHistory: [
        for (final h in r.records('statusHistory'))
          StatusHistoryCompanion.insert(
            id: Value(h.integer('id')),
            applicationId: h.integer('applicationId'),
            fromStatus: Value(
              h.optionalEnum('fromStatus', ApplicationStatus.values),
            ),
            toStatus: h.enumValue('toStatus', ApplicationStatus.values),
            changedAt: h.timestamp('changedAt'),
          ),
      ],
      interviews: [
        for (final i in r.records('interviews'))
          InterviewsCompanion.insert(
            id: Value(i.integer('id')),
            applicationId: i.integer('applicationId'),
            title: i.string('title'),
            format: i.enumValue('format', InterviewFormat.values),
            scheduledAt: i.timestamp('scheduledAt'),
            durationMinutes: Value(i.optionalInteger('durationMinutes')),
            location: Value(i.optionalString('location')),
            interviewer: Value(i.optionalString('interviewer')),
            outcome: Value(i.enumValue('outcome', InterviewOutcome.values)),
            summary: Value(i.optionalString('summary')),
            createdAt: i.timestamp('createdAt'),
            updatedAt: i.timestamp('updatedAt'),
          ),
      ],
      checklistItems: [
        for (final c in r.records('checklistItems'))
          ChecklistItemsCompanion.insert(
            id: Value(c.integer('id')),
            applicationId: c.integer('applicationId'),
            interviewId: Value(c.optionalInteger('interviewId')),
            title: c.string('title'),
            isDone: Value(c.boolean('isDone')),
            position: c.integer('position'),
            completedAt: Value(c.optionalTimestamp('completedAt')),
            createdAt: c.timestamp('createdAt'),
          ),
      ],
      notes: [
        for (final n in r.records('notes'))
          NotesCompanion.insert(
            id: Value(n.integer('id')),
            applicationId: n.integer('applicationId'),
            content: n.string('content'),
            createdAt: n.timestamp('createdAt'),
            updatedAt: n.timestamp('updatedAt'),
          ),
      ],
    );
  }

  /// Replaces **all** data with [snapshot] in one transaction. If anything
  /// is inconsistent (e.g. a note pointing at a missing application), nothing
  /// changes and a [BackupFormatException] is thrown.
  Future<void> restore(BackupSnapshot snapshot) async {
    try {
      await _db.transaction(() async {
        await _deleteEverything();
        await _db.batch((batch) {
          // Parents before children, so foreign keys resolve.
          batch
            ..insertAll(_db.applications, snapshot.applications)
            ..insertAll(_db.statusHistory, snapshot.statusHistory)
            ..insertAll(_db.interviews, snapshot.interviews)
            ..insertAll(_db.checklistItems, snapshot.checklistItems)
            ..insertAll(_db.notes, snapshot.notes);
        });
      });
    } on BackupFormatException {
      rethrow;
    } on Exception {
      throw const BackupFormatException(
        'This backup contains invalid or inconsistent data. '
        'Nothing was changed.',
      );
    }
  }

  /// Deletes every application with its history, interviews, checklist
  /// items and notes.
  Future<void> clearAll() => _db.transaction(_deleteEverything);

  Future<int> applicationCount() => _db.applications.count().getSingle();

  Future<void> _deleteEverything() async {
    // Children first; cascades would handle it, but explicit is clearer.
    for (final table in <TableInfo<Table, Object?>>[
      _db.notes,
      _db.checklistItems,
      _db.interviews,
      _db.statusHistory,
      _db.applications,
    ]) {
      await _db.delete(table).go();
    }
  }

  // --- encoding helpers ------------------------------------------------------

  static String _timestamp(DateTime value) => value.toUtc().toIso8601String();

  static String? _optionalTimestamp(DateTime? value) =>
      value == null ? null : _timestamp(value);

  /// Calendar date of a date-only (or local) value as `yyyy-MM-dd`.
  static String? _date(DateTime? value) {
    if (value == null) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year.toString().padLeft(4, '0')}-'
        '${two(value.month)}-${two(value.day)}';
  }
}

/// Typed access to one JSON object, throwing [BackupFormatException] with the
/// offending field on anything unexpected.
class _Reader {
  _Reader(this._map, this._context);

  final Map<String, Object?> _map;
  final String _context;

  Never _invalid(String key) =>
      throw BackupFormatException('The backup is damaged ($_context.$key).');

  T _get<T>(String key) {
    final value = _map[key];
    return value is T ? value : _invalid(key);
  }

  List<_Reader> records(String key) {
    final list = _get<List<Object?>>(key);
    return [
      for (final (index, item) in list.indexed)
        if (item is Map<String, Object?>)
          _Reader(item, '$key[$index]')
        else
          _invalid('$key[$index]'),
    ];
  }

  int integer(String key) => _get<int>(key);
  int? optionalInteger(String key) => _map[key] == null ? null : integer(key);
  String string(String key) => _get<String>(key);
  String? optionalString(String key) => _map[key] == null ? null : string(key);
  bool boolean(String key) => _get<bool>(key);

  E enumValue<E extends Enum>(String key, List<E> values) =>
      values.asNameMap()[string(key)] ?? _invalid(key);

  E? optionalEnum<E extends Enum>(String key, List<E> values) =>
      _map[key] == null ? null : enumValue(key, values);

  DateTime timestamp(String key) {
    final parsed = DateTime.tryParse(string(key));
    return parsed?.toUtc() ?? _invalid(key);
  }

  DateTime? optionalTimestamp(String key) =>
      _map[key] == null ? null : timestamp(key);

  /// `yyyy-MM-dd` → UTC midnight of that date (the app's date-only form).
  DateTime? optionalDate(String key) {
    if (_map[key] == null) return null;
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(string(key));
    if (match == null) _invalid(key);
    return DateTime.utc(
      int.parse(match[1]!),
      int.parse(match[2]!),
      int.parse(match[3]!),
    );
  }
}
