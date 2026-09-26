import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/services/dashboard_summary.dart';

Application _app(
  int id,
  ApplicationStatus status, {
  DateTime? appliedAt,
  DateTime? deadlineAt,
}) => Application(
  id: id,
  companyName: 'Company $id',
  positionTitle: 'Role $id',
  status: status,
  salaryCurrency: 'IDR',
  appliedAt: appliedAt,
  deadlineAt: deadlineAt,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

void main() {
  final now = DateTime(2026, 9, 26, 10, 30);

  test('empty input gives zeros', () {
    final summary = DashboardSummary.from(const [], now);
    expect(summary.total, 0);
    expect(summary.active, 0);
    expect(summary.offers, 0);
    expect(summary.statusCounts.values.every((c) => c == 0), isTrue);
    expect(summary.upcomingDeadlines, isEmpty);
  });

  test('counts totals, active, offers and this month', () {
    final summary = DashboardSummary.from([
      _app(1, ApplicationStatus.saved),
      _app(2, ApplicationStatus.applied, appliedAt: DateTime.utc(2026, 9, 1)),
      _app(3, ApplicationStatus.offer, appliedAt: DateTime.utc(2026, 9, 30)),
      _app(4, ApplicationStatus.rejected, appliedAt: DateTime.utc(2026, 8, 31)),
      _app(5, ApplicationStatus.withdrawn, appliedAt: DateTime.utc(2025, 9, 5)),
    ], now);

    expect(summary.total, 5);
    expect(summary.active, 3);
    expect(summary.offers, 1);
    // September of a different year is excluded.
    expect(summary.appliedThisMonth, 2);
    expect(summary.statusCounts[ApplicationStatus.rejected], 1);
    expect(summary.statusCounts.keys.toList(), ApplicationStatus.values);
  });

  test(
    'upcoming deadlines: today through 7 days, open only, soonest first',
    () {
      final summary = DashboardSummary.from([
        _app(1, ApplicationStatus.saved, deadlineAt: DateTime.utc(2026, 10, 3)),
        _app(2, ApplicationStatus.saved, deadlineAt: DateTime.utc(2026, 9, 26)),
        _app(3, ApplicationStatus.saved, deadlineAt: DateTime.utc(2026, 10, 4)),
        _app(4, ApplicationStatus.saved, deadlineAt: DateTime.utc(2026, 9, 25)),
        _app(
          5,
          ApplicationStatus.rejected,
          deadlineAt: DateTime.utc(2026, 9, 27),
        ),
        _app(
          6,
          ApplicationStatus.technicalTest,
          deadlineAt: DateTime.utc(2026, 9, 29),
        ),
      ], now);

      expect(summary.upcomingDeadlines.map((a) => a.id), [2, 6, 1]);
    },
  );

  test('greeting follows the time of day', () {
    expect(greetingFor(DateTime(2026, 1, 1, 8)), 'Good morning');
    expect(greetingFor(DateTime(2026, 1, 1, 12)), 'Good afternoon');
    expect(greetingFor(DateTime(2026, 1, 1, 18)), 'Good evening');
  });
}
