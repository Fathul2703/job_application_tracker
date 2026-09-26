import 'package:flutter/foundation.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';

enum ApplicationSort {
  /// Most recently changed first.
  recentlyUpdated('Recently updated'),

  /// Latest applied date first; applications not yet sent go last.
  appliedDate('Applied date'),

  /// Soonest deadline first; applications without a deadline go last.
  deadline('Deadline'),

  /// Company name A–Z (case-insensitive).
  company('Company A–Z');

  const ApplicationSort(this.label);
  final String label;
}

/// Search, filters and sort order for the applications list.
///
/// Empty filter sets mean "no restriction". Values in different sets are
/// combined with AND; values within one set with OR.
@immutable
class ApplicationQuery {
  const ApplicationQuery({
    this.search = '',
    this.statuses = const {},
    this.workModes = const {},
    this.employmentTypes = const {},
    this.sort = ApplicationSort.recentlyUpdated,
  });

  /// Matched against company, position and location. Every word must match
  /// at least one of them.
  final String search;
  final Set<ApplicationStatus> statuses;
  final Set<WorkMode> workModes;
  final Set<EmploymentType> employmentTypes;
  final ApplicationSort sort;

  /// Search split into lowercase words.
  List<String> get searchTerms => search
      .trim()
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((term) => term.isNotEmpty)
      .toList();

  /// Number of filter values set in the filter sheet (search and sort
  /// excluded).
  int get filterCount =>
      statuses.length + workModes.length + employmentTypes.length;

  /// Whether anything narrows the results (search or filters).
  bool get isFiltering => searchTerms.isNotEmpty || filterCount > 0;

  ApplicationQuery copyWith({
    String? search,
    Set<ApplicationStatus>? statuses,
    Set<WorkMode>? workModes,
    Set<EmploymentType>? employmentTypes,
    ApplicationSort? sort,
  }) => ApplicationQuery(
    search: search ?? this.search,
    statuses: statuses ?? this.statuses,
    workModes: workModes ?? this.workModes,
    employmentTypes: employmentTypes ?? this.employmentTypes,
    sort: sort ?? this.sort,
  );

  /// Clears search and filters but keeps the sort order.
  ApplicationQuery cleared() => ApplicationQuery(sort: sort);

  @override
  bool operator ==(Object other) =>
      other is ApplicationQuery &&
      other.search == search &&
      setEquals(other.statuses, statuses) &&
      setEquals(other.workModes, workModes) &&
      setEquals(other.employmentTypes, employmentTypes) &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(
    search,
    Object.hashAllUnordered(statuses),
    Object.hashAllUnordered(workModes),
    Object.hashAllUnordered(employmentTypes),
    sort,
  );
}

extension SetToggle<T> on Set<T> {
  /// A copy with [value] added, or removed if already present.
  Set<T> toggled(T value) =>
      contains(value) ? ({...this}..remove(value)) : {...this, value};
}
