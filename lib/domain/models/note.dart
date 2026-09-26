import 'package:flutter/foundation.dart';

/// A free-form note attached to an application.
@immutable
class Note {
  const Note({
    required this.id,
    required this.applicationId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int applicationId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      other is Note &&
      other.id == id &&
      other.applicationId == applicationId &&
      other.content == content &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      Object.hash(id, applicationId, content, createdAt, updatedAt);

  @override
  String toString() => 'Note($id, application: $applicationId)';
}
