import 'package:flutter/foundation.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';

/// A job application as stored in the app.
///
/// [appliedAt] and [deadlineAt] are date-only values (see `DateOnly`).
/// [createdAt] and [updatedAt] are UTC timestamps.
@immutable
class Application {
  const Application({
    required this.id,
    required this.companyName,
    required this.positionTitle,
    required this.status,
    required this.salaryCurrency,
    required this.createdAt,
    required this.updatedAt,
    this.location,
    this.workMode,
    this.employmentType,
    this.salaryMin,
    this.salaryMax,
    this.salaryPeriod,
    this.jobUrl,
    this.appliedAt,
    this.deadlineAt,
  });

  final int id;
  final String companyName;
  final String positionTitle;
  final String? location;
  final WorkMode? workMode;
  final EmploymentType? employmentType;
  final int? salaryMin;
  final int? salaryMax;
  final String salaryCurrency;
  final SalaryPeriod? salaryPeriod;
  final String? jobUrl;
  final ApplicationStatus status;
  final DateTime? appliedAt;
  final DateTime? deadlineAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Whether the application was actually sent (counts as "submitted" in
  /// analytics).
  bool get isSubmitted => appliedAt != null;

  ApplicationDraft toDraft() => ApplicationDraft(
    companyName: companyName,
    positionTitle: positionTitle,
    location: location,
    workMode: workMode,
    employmentType: employmentType,
    salaryMin: salaryMin,
    salaryMax: salaryMax,
    salaryCurrency: salaryCurrency,
    salaryPeriod: salaryPeriod,
    jobUrl: jobUrl,
    status: status,
    appliedAt: appliedAt,
    deadlineAt: deadlineAt,
  );

  @override
  bool operator ==(Object other) =>
      other is Application &&
      other.id == id &&
      other.companyName == companyName &&
      other.positionTitle == positionTitle &&
      other.location == location &&
      other.workMode == workMode &&
      other.employmentType == employmentType &&
      other.salaryMin == salaryMin &&
      other.salaryMax == salaryMax &&
      other.salaryCurrency == salaryCurrency &&
      other.salaryPeriod == salaryPeriod &&
      other.jobUrl == jobUrl &&
      other.status == status &&
      other.appliedAt == appliedAt &&
      other.deadlineAt == deadlineAt &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    companyName,
    positionTitle,
    location,
    workMode,
    employmentType,
    salaryMin,
    salaryMax,
    salaryCurrency,
    salaryPeriod,
    jobUrl,
    status,
    appliedAt,
    deadlineAt,
    createdAt,
    updatedAt,
  );

  @override
  String toString() =>
      'Application($id, $companyName, $positionTitle, ${status.name})';
}

/// User-editable fields of an [Application], used to create or update one.
@immutable
class ApplicationDraft {
  const ApplicationDraft({
    required this.companyName,
    required this.positionTitle,
    this.location,
    this.workMode,
    this.employmentType,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency = defaultCurrency,
    this.salaryPeriod,
    this.jobUrl,
    this.status = ApplicationStatus.saved,
    this.appliedAt,
    this.deadlineAt,
  });

  static const String defaultCurrency = 'IDR';
  static const int maxTextLength = 200;

  final String companyName;
  final String positionTitle;
  final String? location;
  final WorkMode? workMode;
  final EmploymentType? employmentType;
  final int? salaryMin;
  final int? salaryMax;
  final String salaryCurrency;
  final SalaryPeriod? salaryPeriod;
  final String? jobUrl;
  final ApplicationStatus status;
  final DateTime? appliedAt;
  final DateTime? deadlineAt;

  /// Returns human-readable problems, or an empty list when valid.
  List<String> validate() {
    final company = companyName.trim();
    final position = positionTitle.trim();
    final min = salaryMin;
    final max = salaryMax;
    return [
      if (company.isEmpty) 'Company is required.',
      if (company.length > maxTextLength)
        'Company must be at most $maxTextLength characters.',
      if (position.isEmpty) 'Position is required.',
      if (position.length > maxTextLength)
        'Position must be at most $maxTextLength characters.',
      if ((min != null && min < 0) || (max != null && max < 0))
        'Salary cannot be negative.',
      if (min != null && max != null && min > max)
        'Minimum salary cannot exceed maximum salary.',
      if (!RegExp(r'^[A-Z]{3}$').hasMatch(salaryCurrency))
        'Currency must be a 3-letter ISO code.',
    ];
  }
}
