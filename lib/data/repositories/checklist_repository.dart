import 'package:drift/drift.dart';
import 'package:job_application_tracker/core/utils/clock.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/domain/models/checklist_item.dart';

class ChecklistRepository {
  ChecklistRepository(this._db, {this._clock = DateTime.now});

  final AppDatabase _db;
  final Clock _clock;

  $ChecklistItemsTable get _table => _db.checklistItems;

  /// Checklist of one application in display order.
  Stream<List<ChecklistItem>> watchForApplication(int applicationId) {
    final query = _db.select(_table)
      ..where((t) => t.applicationId.equals(applicationId))
      ..orderBy([
        (t) => OrderingTerm.asc(t.position),
        (t) => OrderingTerm.asc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  /// Appends an item at the end of the application's checklist.
  Future<int> add(int applicationId, String title, {int? interviewId}) async {
    final trimmed = _validTitle(title);
    return _db.transaction(() async {
      if (interviewId != null) {
        await _ensureInterviewBelongsTo(interviewId, applicationId);
      }
      final maxPosition = _table.position.max();
      final last =
          await (_db.selectOnly(_table)
                ..addColumns([maxPosition])
                ..where(_table.applicationId.equals(applicationId)))
              .map((row) => row.read(maxPosition))
              .getSingle();
      return _db
          .into(_table)
          .insert(
            ChecklistItemsCompanion.insert(
              applicationId: applicationId,
              interviewId: Value(interviewId),
              title: trimmed,
              position: last == null ? 0 : last + 1,
              createdAt: _clock().toUtc(),
            ),
          );
    });
  }

  Future<void> setDone(int id, {required bool isDone}) => _write(
    id,
    ChecklistItemsCompanion(
      isDone: Value(isDone),
      completedAt: Value(isDone ? _clock().toUtc() : null),
    ),
  );

  Future<void> rename(int id, String title) async =>
      _write(id, ChecklistItemsCompanion(title: Value(_validTitle(title))));

  /// Links the item to an interview of the same application, or unlinks it
  /// when [interviewId] is `null`.
  Future<void> linkToInterview(int id, int? interviewId) async {
    await _db.transaction(() async {
      final item = await (_db.select(
        _table,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (item == null) throw NotFoundException('Checklist item', id);
      if (interviewId != null) {
        await _ensureInterviewBelongsTo(interviewId, item.applicationId);
      }
      await _write(
        id,
        ChecklistItemsCompanion(interviewId: Value(interviewId)),
      );
    });
  }

  Future<void> delete(int id) =>
      (_db.delete(_table)..where((t) => t.id.equals(id))).go();

  /// Persists a new order. [orderedIds] must contain exactly the ids of the
  /// application's checklist items.
  Future<void> reorder(int applicationId, List<int> orderedIds) async {
    return _db.transaction(() async {
      final existing =
          await (_db.selectOnly(_table)
                ..addColumns([_table.id])
                ..where(_table.applicationId.equals(applicationId)))
              .map((row) => row.read(_table.id)!)
              .get();
      if (existing.length != orderedIds.length ||
          !existing.toSet().containsAll(orderedIds)) {
        throw ArgumentError.value(
          orderedIds,
          'orderedIds',
          'Must list every checklist item of application $applicationId once',
        );
      }
      for (final (index, id) in orderedIds.indexed) {
        await (_db.update(_table)..where((t) => t.id.equals(id))).write(
          ChecklistItemsCompanion(position: Value(index)),
        );
      }
    });
  }

  Future<void> _ensureInterviewBelongsTo(
    int interviewId,
    int applicationId,
  ) async {
    final interview = await (_db.select(
      _db.interviews,
    )..where((t) => t.id.equals(interviewId))).getSingleOrNull();
    if (interview == null) throw NotFoundException('Interview', interviewId);
    if (interview.applicationId != applicationId) {
      throw ArgumentError.value(
        interviewId,
        'interviewId',
        'Interview belongs to a different application',
      );
    }
  }

  Future<void> _write(int id, ChecklistItemsCompanion companion) async {
    final updated = await (_db.update(
      _table,
    )..where((t) => t.id.equals(id))).write(companion);
    if (updated == 0) throw NotFoundException('Checklist item', id);
  }

  static String _validTitle(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw const ValidationException(['Checklist item cannot be empty.']);
    }
    if (trimmed.length > ChecklistItem.maxTitleLength) {
      throw const ValidationException([
        'Checklist item must be at most '
            '${ChecklistItem.maxTitleLength} characters.',
      ]);
    }
    return trimmed;
  }

  static ChecklistItem _toModel(ChecklistItemRow row) => ChecklistItem(
    id: row.id,
    applicationId: row.applicationId,
    interviewId: row.interviewId,
    title: row.title,
    isDone: row.isDone,
    position: row.position,
    completedAt: row.completedAt,
    createdAt: row.createdAt,
  );
}
