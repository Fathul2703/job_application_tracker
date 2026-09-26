import 'package:flutter/foundation.dart';

/// An interview-preparation task for an application, optionally tied to a
/// specific interview.
@immutable
class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.applicationId,
    required this.title,
    required this.isDone,
    required this.position,
    required this.createdAt,
    this.interviewId,
    this.completedAt,
  });

  static const int maxTitleLength = 200;

  final int id;
  final int applicationId;
  final int? interviewId;
  final String title;
  final bool isDone;

  /// Sort order within the application, starting at 0.
  final int position;
  final DateTime? completedAt;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) =>
      other is ChecklistItem &&
      other.id == id &&
      other.applicationId == applicationId &&
      other.interviewId == interviewId &&
      other.title == title &&
      other.isDone == isDone &&
      other.position == position &&
      other.completedAt == completedAt &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(
    id,
    applicationId,
    interviewId,
    title,
    isDone,
    position,
    completedAt,
    createdAt,
  );

  @override
  String toString() => 'ChecklistItem($id, $title, done: $isDone)';
}
