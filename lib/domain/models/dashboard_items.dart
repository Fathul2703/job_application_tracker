import 'package:flutter/foundation.dart';
import 'package:job_application_tracker/domain/models/interview.dart';
import 'package:job_application_tracker/domain/models/status_change.dart';

/// An interview together with the application it belongs to, for lists that
/// span all applications (e.g. the dashboard).
@immutable
class UpcomingInterview {
  const UpcomingInterview({
    required this.interview,
    required this.companyName,
    required this.positionTitle,
  });

  final Interview interview;
  final String companyName;
  final String positionTitle;

  int get applicationId => interview.applicationId;
}

/// A status change together with its application, for activity feeds.
@immutable
class RecentStatusChange {
  const RecentStatusChange({
    required this.change,
    required this.companyName,
    required this.positionTitle,
  });

  final StatusChange change;
  final String companyName;
  final String positionTitle;

  int get applicationId => change.applicationId;
}
