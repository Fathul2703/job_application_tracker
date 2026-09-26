import 'package:flutter/foundation.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';

/// One entry in an application's status history.
@immutable
class StatusChange {
  const StatusChange({
    required this.id,
    required this.applicationId,
    required this.toStatus,
    required this.changedAt,
    this.fromStatus,
  });

  final int id;
  final int applicationId;

  /// `null` for the initial status recorded when the application was created.
  final ApplicationStatus? fromStatus;
  final ApplicationStatus toStatus;

  /// UTC timestamp.
  final DateTime changedAt;

  @override
  bool operator ==(Object other) =>
      other is StatusChange &&
      other.id == id &&
      other.applicationId == applicationId &&
      other.fromStatus == fromStatus &&
      other.toStatus == toStatus &&
      other.changedAt == changedAt;

  @override
  int get hashCode =>
      Object.hash(id, applicationId, fromStatus, toStatus, changedAt);

  @override
  String toString() =>
      'StatusChange($applicationId: ${fromStatus?.name} → ${toStatus.name})';
}
