import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/domain/models/status_change.dart';
import 'package:job_application_tracker/domain/services/analytics.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

final analyticsPeriodProvider =
    NotifierProvider<AnalyticsPeriodController, AnalyticsPeriod>(
      AnalyticsPeriodController.new,
    );

class AnalyticsPeriodController extends Notifier<AnalyticsPeriod> {
  @override
  AnalyticsPeriod build() => AnalyticsPeriod.allTime;

  void select(AnalyticsPeriod period) => state = period;
}

final _allStatusHistoryProvider = StreamProvider<List<StatusChange>>(
  (ref) => ref.watch(applicationRepositoryProvider).watchAllStatusHistory(),
);

final _interviewedApplicationIdsProvider = StreamProvider<Set<int>>(
  (ref) => ref
      .watch(interviewRepositoryProvider)
      .watchApplicationIdsWithInterviews(),
);

/// The analytics report for the selected period. Recomputed whenever
/// applications, their history or interviews change.
final analyticsReportProvider = Provider<AsyncValue<AnalyticsReport>>((ref) {
  final applications = ref.watch(applicationsProvider);
  final history = ref.watch(_allStatusHistoryProvider);
  final interviewed = ref.watch(_interviewedApplicationIdsProvider);

  if (applications.value case final apps?) {
    if (history.value case final changes?) {
      if (interviewed.value case final ids?) {
        return AsyncData(
          Analytics.build(
            applications: apps,
            history: changes,
            interviewedApplicationIds: ids,
            now: ref.watch(clockProvider)(),
            period: ref.watch(analyticsPeriodProvider),
          ),
        );
      }
    }
  }
  for (final source in [applications, history, interviewed]) {
    if (source case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  return const AsyncLoading();
});
