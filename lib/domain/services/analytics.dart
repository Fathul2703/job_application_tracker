import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:job_application_tracker/core/utils/date_only.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/status_change.dart';

enum AnalyticsPeriod {
  allTime('All time', null),
  sixMonths('6 months', 6),
  threeMonths('3 months', 3);

  const AnalyticsPeriod(this.label, this.months);

  final String label;

  /// Calendar months covered, including the current one; `null` = all time.
  final int? months;

  /// First day of the window as a date-only value, or `null` for all time.
  DateTime? startFor(DateTime now) {
    final count = months;
    return count == null ? null : DateTime.utc(now.year, now.month - count + 1);
  }
}

/// A count out of a total, e.g. 8 of 11. [value] is `null` when the total
/// is zero, so the UI never shows a misleading 0%.
@immutable
class Rate {
  const Rate(this.count, this.total);

  final int count;
  final int total;

  double? get value => total == 0 ? null : count / total;

  @override
  bool operator ==(Object other) =>
      other is Rate && other.count == count && other.total == total;

  @override
  int get hashCode => Object.hash(count, total);

  @override
  String toString() => 'Rate($count/$total)';
}

/// Outcomes of the applications sent in one calendar month.
@immutable
class MonthStats {
  const MonthStats({
    required this.month,
    required this.applied,
    required this.responses,
    required this.interviews,
    required this.offers,
  });

  /// First day of the month (UTC, date-only).
  final DateTime month;
  final int applied;
  final int responses;
  final int interviews;
  final int offers;
}

@immutable
class AnalyticsReport {
  const AnalyticsReport({
    required this.period,
    required this.submitted,
    required this.responseRate,
    required this.interviewRate,
    required this.offerRate,
    required this.medianDaysToResponse,
    required this.statusCounts,
    required this.months,
    required this.monthsTruncated,
  });

  final AnalyticsPeriod period;

  /// Applications sent (applied date set) within the period.
  final int submitted;
  final Rate responseRate;
  final Rate interviewRate;
  final Rate offerRate;

  /// Median calendar days from applying to the first response, or `null`
  /// when nothing got a response yet.
  final int? medianDaysToResponse;

  /// Current status of every application in the period (by applied date,
  /// or added date if never sent), in pipeline order.
  final Map<ApplicationStatus, int> statusCounts;

  /// Oldest first, one entry per calendar month (zeros included).
  final List<MonthStats> months;

  /// Whether older months exist but were left out of [months].
  final bool monthsTruncated;
}

/// Computes analytics using the metric definitions in CLAUDE.md:
///
/// - **Submitted**: `appliedAt` is set (and within the period).
/// - **Response**: ever reached Screening or later, or Rejected.
///   Withdrawn is not a response.
/// - **Interview**: ever reached Interview, Technical Test or Offer, or has
///   at least one interview that wasn't cancelled.
/// - **Offer**: ever reached Offer.
///
/// "Ever reached" uses the status history plus the current status, so an
/// application that was interviewed and later rejected still counts.
abstract final class Analytics {
  /// At most this many months are listed for "All time".
  static const maxMonths = 12;

  static const _responseStatuses = {
    ApplicationStatus.screening,
    ApplicationStatus.interview,
    ApplicationStatus.technicalTest,
    ApplicationStatus.offer,
    ApplicationStatus.rejected,
  };

  static const _interviewStatuses = {
    ApplicationStatus.interview,
    ApplicationStatus.technicalTest,
    ApplicationStatus.offer,
  };

  static AnalyticsReport build({
    required List<Application> applications,
    required List<StatusChange> history,
    required Set<int> interviewedApplicationIds,
    required DateTime now,
    required AnalyticsPeriod period,
  }) {
    final historyByApp = <int, List<StatusChange>>{};
    for (final change in history) {
      historyByApp.putIfAbsent(change.applicationId, () => []).add(change);
    }

    Set<ApplicationStatus> reached(Application app) => {
      app.status,
      for (final change in historyByApp[app.id] ?? const <StatusChange>[])
        change.toStatus,
    };
    bool responded(Application app) =>
        reached(app).any(_responseStatuses.contains);
    bool interviewed(Application app) =>
        interviewedApplicationIds.contains(app.id) ||
        reached(app).any(_interviewStatuses.contains);
    bool offered(Application app) =>
        reached(app).contains(ApplicationStatus.offer);

    final start = period.startFor(now);
    bool inPeriod(DateTime dateOnly) =>
        start == null || !dateOnly.isBefore(start);

    final sent = [
      for (final app in applications)
        if (app.appliedAt case final applied? when inPeriod(applied)) app,
    ];

    final counts = {for (final status in ApplicationStatus.values) status: 0};
    for (final app in applications) {
      final date = app.appliedAt ?? app.createdAt.toLocal().toDateOnly();
      if (inPeriod(date)) counts[app.status] = counts[app.status]! + 1;
    }

    final (months, truncated) = _months(
      sent,
      now: now,
      start: start,
      responded: responded,
      interviewed: interviewed,
      offered: offered,
    );

    return AnalyticsReport(
      period: period,
      submitted: sent.length,
      responseRate: Rate(sent.where(responded).length, sent.length),
      interviewRate: Rate(sent.where(interviewed).length, sent.length),
      offerRate: Rate(sent.where(offered).length, sent.length),
      medianDaysToResponse: _median([
        for (final app in sent)
          ?_daysToFirstResponse(app, historyByApp[app.id]),
      ]),
      statusCounts: Map.unmodifiable(counts),
      months: List.unmodifiable(months),
      monthsTruncated: truncated,
    );
  }

  static (List<MonthStats>, bool) _months(
    List<Application> sent, {
    required DateTime now,
    required DateTime? start,
    required bool Function(Application) responded,
    required bool Function(Application) interviewed,
    required bool Function(Application) offered,
  }) {
    final current = DateTime.utc(now.year, now.month);
    var first = start;
    if (first == null) {
      final earliest = sent
          .map((a) => a.appliedAt!)
          .fold<DateTime?>(
            null,
            (min, d) => min == null || d.isBefore(min) ? d : min,
          );
      first = earliest == null
          ? current
          : DateTime.utc(earliest.year, earliest.month);
    }
    final oldestShown = DateTime.utc(now.year, now.month - maxMonths + 1);
    final truncated = first.isBefore(oldestShown);
    if (truncated) first = oldestShown;

    final months = <MonthStats>[];
    for (
      var m = first;
      !m.isAfter(current);
      m = DateTime.utc(m.year, m.month + 1)
    ) {
      final inMonth = sent.where(
        (a) => a.appliedAt!.year == m.year && a.appliedAt!.month == m.month,
      );
      months.add(
        MonthStats(
          month: m,
          applied: inMonth.length,
          responses: inMonth.where(responded).length,
          interviews: inMonth.where(interviewed).length,
          offers: inMonth.where(offered).length,
        ),
      );
    }
    return (months, truncated);
  }

  /// Calendar days from the applied date to the first response in history.
  static int? _daysToFirstResponse(
    Application app,
    List<StatusChange>? history,
  ) {
    final applied = app.appliedAt;
    if (applied == null || history == null) return null;
    for (final change in history) {
      if (_responseStatuses.contains(change.toStatus)) {
        final day = change.changedAt.toLocal().toDateOnly();
        return math.max(0, day.difference(applied).inDays);
      }
    }
    return null;
  }

  static int? _median(List<int> values) {
    if (values.isEmpty) return null;
    final sorted = [...values]..sort();
    final mid = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[mid]
        : ((sorted[mid - 1] + sorted[mid]) / 2).round();
  }
}
