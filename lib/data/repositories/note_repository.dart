import 'package:drift/drift.dart';
import 'package:job_application_tracker/core/utils/clock.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/domain/errors.dart';
import 'package:job_application_tracker/domain/models/note.dart';

class NoteRepository {
  NoteRepository(this._db, {this._clock = DateTime.now});

  final AppDatabase _db;
  final Clock _clock;

  $NotesTable get _table => _db.notes;

  /// Notes of one application, newest first.
  Stream<List<Note>> watchForApplication(int applicationId) {
    final query = _db.select(_table)
      ..where((t) => t.applicationId.equals(applicationId))
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toModel).toList());
  }

  Future<int> add(int applicationId, String content) async {
    final timestamp = _clock().toUtc();
    return _db
        .into(_table)
        .insert(
          NotesCompanion.insert(
            applicationId: applicationId,
            content: _validContent(content),
            createdAt: timestamp,
            updatedAt: timestamp,
          ),
        );
  }

  Future<void> update(int id, String content) async {
    final updated = await (_db.update(_table)..where((t) => t.id.equals(id)))
        .write(
          NotesCompanion(
            content: Value(_validContent(content)),
            updatedAt: Value(_clock().toUtc()),
          ),
        );
    if (updated == 0) throw NotFoundException('Note', id);
  }

  Future<void> delete(int id) =>
      (_db.delete(_table)..where((t) => t.id.equals(id))).go();

  static String _validContent(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      throw const ValidationException(['Note cannot be empty.']);
    }
    return trimmed;
  }

  static Note _toModel(NoteRow row) => Note(
    id: row.id,
    applicationId: row.applicationId,
    content: row.content,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
