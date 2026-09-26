import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/application_query.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

/// Search, filters and sort of the Applications tab. Kept alive for the
/// session so they survive switching tabs.
final applicationQueryProvider =
    NotifierProvider<ApplicationQueryController, ApplicationQuery>(
      ApplicationQueryController.new,
    );

class ApplicationQueryController extends Notifier<ApplicationQuery> {
  @override
  ApplicationQuery build() => const ApplicationQuery();

  void setSearch(String search) => state = state.copyWith(search: search);

  void toggleStatus(ApplicationStatus status) =>
      state = state.copyWith(statuses: state.statuses.toggled(status));

  void toggleWorkMode(WorkMode mode) =>
      state = state.copyWith(workModes: state.workModes.toggled(mode));

  void toggleEmploymentType(EmploymentType type) => state = state.copyWith(
    employmentTypes: state.employmentTypes.toggled(type),
  );

  void setSort(ApplicationSort sort) => state = state.copyWith(sort: sort);

  /// Clears only the filter sheet values, keeping search and sort.
  void clearFilters() =>
      state = ApplicationQuery(search: state.search, sort: state.sort);

  /// Clears search and filters, keeping sort.
  void clearAll() => state = state.cleared();
}

/// Applications matching the current query, filtered and sorted in SQL.
final filteredApplicationsProvider = StreamProvider<List<Application>>(
  (ref) => ref
      .watch(applicationRepositoryProvider)
      .watchAll(query: ref.watch(applicationQueryProvider)),
);
