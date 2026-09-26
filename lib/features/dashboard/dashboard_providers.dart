import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/domain/models/dashboard_items.dart';
import 'package:job_application_tracker/domain/services/dashboard_summary.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

/// Summary numbers, deadlines and status counts from all applications.
final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>(
  (ref) => ref
      .watch(applicationsProvider)
      .whenData(
        (apps) => DashboardSummary.from(apps, ref.watch(clockProvider)()),
      ),
);

/// Interviews from the start of today up to [DashboardSummary.upcomingDays]
/// ahead, across all applications. Starting at midnight keeps today's
/// earlier interviews visible for the rest of the day.
final upcomingInterviewsProvider = StreamProvider<List<UpcomingInterview>>((
  ref,
) {
  final now = ref.watch(clockProvider)();
  final startOfToday = DateTime(now.year, now.month, now.day);
  return ref
      .watch(interviewRepositoryProvider)
      .watchUpcoming(
        from: startOfToday,
        until: startOfToday.add(
          const Duration(days: DashboardSummary.upcomingDays + 1),
        ),
      );
});

/// Latest status changes across all applications.
final recentActivityProvider = StreamProvider<List<RecentStatusChange>>(
  (ref) => ref.watch(applicationRepositoryProvider).watchRecentActivity(),
);
