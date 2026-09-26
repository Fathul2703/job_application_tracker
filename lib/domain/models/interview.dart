import 'package:flutter/foundation.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';

/// A scheduled interview round for an application.
@immutable
class Interview {
  const Interview({
    required this.id,
    required this.applicationId,
    required this.title,
    required this.format,
    required this.scheduledAt,
    required this.outcome,
    required this.createdAt,
    required this.updatedAt,
    this.durationMinutes,
    this.location,
    this.interviewer,
    this.summary,
  });

  final int id;
  final int applicationId;

  /// e.g. "HR Interview", "User Interview".
  final String title;
  final InterviewFormat format;

  /// UTC timestamp.
  final DateTime scheduledAt;
  final int? durationMinutes;

  /// Address or meeting link.
  final String? location;
  final String? interviewer;
  final InterviewOutcome outcome;
  final String? summary;
  final DateTime createdAt;
  final DateTime updatedAt;

  InterviewDraft toDraft() => InterviewDraft(
    title: title,
    format: format,
    scheduledAt: scheduledAt,
    durationMinutes: durationMinutes,
    location: location,
    interviewer: interviewer,
    outcome: outcome,
    summary: summary,
  );

  @override
  bool operator ==(Object other) =>
      other is Interview &&
      other.id == id &&
      other.applicationId == applicationId &&
      other.title == title &&
      other.format == format &&
      other.scheduledAt == scheduledAt &&
      other.durationMinutes == durationMinutes &&
      other.location == location &&
      other.interviewer == interviewer &&
      other.outcome == outcome &&
      other.summary == summary &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    applicationId,
    title,
    format,
    scheduledAt,
    durationMinutes,
    location,
    interviewer,
    outcome,
    summary,
    createdAt,
    updatedAt,
  );

  @override
  String toString() => 'Interview($id, $title, $scheduledAt)';
}

/// User-editable fields of an [Interview].
@immutable
class InterviewDraft {
  const InterviewDraft({
    required this.title,
    required this.format,
    required this.scheduledAt,
    this.durationMinutes,
    this.location,
    this.interviewer,
    this.outcome = InterviewOutcome.pending,
    this.summary,
  });

  static const int maxTitleLength = 120;

  final String title;
  final InterviewFormat format;
  final DateTime scheduledAt;
  final int? durationMinutes;
  final String? location;
  final String? interviewer;
  final InterviewOutcome outcome;
  final String? summary;

  List<String> validate() {
    final trimmed = title.trim();
    final duration = durationMinutes;
    return [
      if (trimmed.isEmpty) 'Title is required.',
      if (trimmed.length > maxTitleLength)
        'Title must be at most $maxTitleLength characters.',
      if (duration != null && duration <= 0)
        'Duration must be greater than zero.',
    ];
  }
}
