import 'package:flutter/foundation.dart';
import 'package:job_application_tracker/core/utils/date_only.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';

/// Numbers and lists shown on the dashboard, computed from all
/// applications. Pure: no Flutter, no database.
@immutable
class DashboardSummary {
  const DashboardSummary({
    required this.total,
    required this.active,
    required this.appliedThisMonth,
    required this.offers,
    required this.statusCounts,
    required this.upcomingDeadlines,
  });

  /// How many days ahead count as "upcoming".
  static const upcomingDays = 7;

  factory DashboardSummary.from(List<Application> applications, DateTime now) {
    final today = now.toDateOnly();
    final horizon = today.add(const Duration(days: upcomingDays));

    final counts = {for (final status in ApplicationStatus.values) status: 0};
    for (final app in applications) {
      counts[app.status] = counts[app.status]! + 1;
    }

    final deadlines = applications.where((app) {
      final deadline = app.deadlineAt;
      return deadline != null &&
          !app.status.isTerminal &&
          !deadline.isBefore(today) &&
          !deadline.isAfter(horizon);
    }).toList()..sort((a, b) => a.deadlineAt!.compareTo(b.deadlineAt!));

    return DashboardSummary(
      total: applications.length,
      active: applications.where((a) => !a.status.isTerminal).length,
      appliedThisMonth: applications.where((a) {
        final applied = a.appliedAt;
        return applied != null &&
            applied.year == now.year &&
            applied.month == now.month;
      }).length,
      offers: counts[ApplicationStatus.offer]!,
      statusCounts: Map.unmodifiable(counts),
      upcomingDeadlines: List.unmodifiable(deadlines),
    );
  }

  final int total;

  /// Not rejected or withdrawn.
  final int active;

  /// Applications whose applied date falls in the current calendar month.
  final int appliedThisMonth;
  final int offers;

  /// Count per status, in pipeline order, including zeros.
  final Map<ApplicationStatus, int> statusCounts;

  /// Open applications with a deadline from today up to [upcomingDays]
  /// days ahead, soonest first.
  final List<Application> upcomingDeadlines;
}

/// "Good morning" / "Good afternoon" / "Good evening" for [now]'s hour.
String greetingFor(DateTime now) => switch (now.hour) {
  < 12 => 'Good morning',
  < 18 => 'Good afternoon',
  _ => 'Good evening',
};
