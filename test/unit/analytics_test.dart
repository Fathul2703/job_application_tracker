import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/status_change.dart';
import 'package:job_application_tracker/domain/services/analytics.dart';

final _now = DateTime(2026, 9, 26, 10, 30);

Application _app(
  int id,
  ApplicationStatus status, {
  DateTime? appliedAt,
  DateTime? createdAt,
}) => Application(
  id: id,
  companyName: 'Company $id',
  positionTitle: 'Role $id',
  status: status,
  salaryCurrency: 'IDR',
  appliedAt: appliedAt,
  createdAt: createdAt ?? DateTime.utc(2026, 9, 1),
  updatedAt: DateTime.utc(2026, 9, 1),
);

var _nextId = 1;

/// A status path for [appId]; each step one day after the previous,
/// starting at [start].
List<StatusChange> _path(
  int appId,
  DateTime start,
  List<ApplicationStatus> statuses,
) {
  ApplicationStatus? previous;
  return [
    for (final (i, status) in statuses.indexed)
      StatusChange(
        id: _nextId++,
        applicationId: appId,
        fromStatus: previous,
        toStatus: previous = status,
        changedAt: start.add(Duration(days: i)),
      ),
  ];
}

AnalyticsReport _build(
  List<Application> apps, {
  List<StatusChange> history = const [],
  Set<int> interviewed = const {},
  AnalyticsPeriod period = AnalyticsPeriod.allTime,
}) => Analytics.build(
  applications: apps,
  history: history,
  interviewedApplicationIds: interviewed,
  now: _now,
  period: period,
);

void main() {
  const s = ApplicationStatus.saved;
  const ap = ApplicationStatus.applied;
  const sc = ApplicationStatus.screening;
  const iv = ApplicationStatus.interview;
  const tt = ApplicationStatus.technicalTest;
  const of = ApplicationStatus.offer;
  const rj = ApplicationStatus.rejected;
  const wd = ApplicationStatus.withdrawn;
  final sep1 = DateTime.utc(2026, 9, 1);

  test('no data: zero submitted and rates without a value', () {
    final report = _build(const []);
    expect(report.submitted, 0);
    expect(report.responseRate, const Rate(0, 0));
    expect(report.responseRate.value, isNull);
    expect(report.medianDaysToResponse, isNull);
    expect(report.months, hasLength(1)); // Just the current month.
  });

  test('only applications with an applied date count as submitted', () {
    final report = _build([_app(1, s), _app(2, ap, appliedAt: sep1)]);
    expect(report.submitted, 1);
  });

  group('response rate', () {
    test('screening or later, or rejected, counts; withdrawn does not', () {
      final apps = [
        _app(1, ap, appliedAt: sep1),
        _app(2, sc, appliedAt: sep1),
        _app(3, rj, appliedAt: sep1),
        _app(4, wd, appliedAt: sep1),
        _app(5, of, appliedAt: sep1),
      ];
      expect(_build(apps).responseRate, const Rate(3, 5));
    });

    test('uses history: screening then withdrawn still responded', () {
      final report = _build([
        _app(1, wd, appliedAt: sep1),
      ], history: _path(1, sep1, [ap, sc, wd]));
      expect(report.responseRate, const Rate(1, 1));
    });
  });

  group('interview rate', () {
    test('reached interview, technical test or offer (via history)', () {
      final apps = [
        _app(1, rj, appliedAt: sep1),
        _app(2, tt, appliedAt: sep1),
        _app(3, rj, appliedAt: sep1),
        _app(4, sc, appliedAt: sep1),
      ];
      final report = _build(
        apps,
        history: [
          ..._path(1, sep1, [ap, iv, rj]),
          ..._path(3, sep1, [ap, rj]),
        ],
      );
      expect(report.interviewRate, const Rate(2, 4));
    });

    test('an interview record counts even without the status', () {
      final report = _build(
        [_app(1, sc, appliedAt: sep1), _app(2, sc, appliedAt: sep1)],
        interviewed: {2},
      );
      expect(report.interviewRate, const Rate(1, 2));
    });
  });

  test('offer rate uses history', () {
    final report = _build([
      _app(1, wd, appliedAt: sep1),
      _app(2, rj, appliedAt: sep1),
    ], history: _path(1, sep1, [ap, iv, of, wd]));
    expect(report.offerRate, const Rate(1, 2));
  });

  group('period', () {
    final apps = [
      _app(1, ap, appliedAt: DateTime.utc(2026, 9, 10)),
      _app(2, ap, appliedAt: DateTime.utc(2026, 7, 1)),
      _app(3, ap, appliedAt: DateTime.utc(2026, 6, 30)),
      _app(4, ap, appliedAt: DateTime.utc(2026, 4, 1)),
      _app(5, ap, appliedAt: DateTime.utc(2026, 3, 31)),
      _app(6, s, createdAt: DateTime.utc(2026, 1, 5)),
    ];

    test('3 and 6 months include the current month', () {
      expect(AnalyticsPeriod.threeMonths.startFor(_now), DateTime.utc(2026, 7));
      expect(_build(apps, period: AnalyticsPeriod.threeMonths).submitted, 2);
      expect(_build(apps, period: AnalyticsPeriod.sixMonths).submitted, 4);
      expect(_build(apps).submitted, 5);
    });

    test('status counts use added date for unsent applications', () {
      final threeMonths = _build(apps, period: AnalyticsPeriod.threeMonths);
      expect(threeMonths.statusCounts[s], 0);
      expect(_build(apps).statusCounts[s], 1);
    });
  });

  group('months', () {
    test('one entry per month in the window, zeros included', () {
      final report = _build([
        _app(1, sc, appliedAt: DateTime.utc(2026, 7, 3)),
        _app(2, ap, appliedAt: DateTime.utc(2026, 9, 2)),
        _app(3, of, appliedAt: DateTime.utc(2026, 9, 20)),
      ], period: AnalyticsPeriod.threeMonths);
      expect(report.months.map((m) => m.month), [
        DateTime.utc(2026, 7),
        DateTime.utc(2026, 8),
        DateTime.utc(2026, 9),
      ]);
      expect(report.months.map((m) => m.applied), [1, 0, 2]);
      expect(report.months.map((m) => m.responses), [1, 0, 1]);
      expect(report.months.last.offers, 1);
      expect(report.monthsTruncated, isFalse);
    });

    test('all time starts at the first applied month, capped at 12', () {
      final recent = _build([_app(1, ap, appliedAt: DateTime.utc(2026, 5, 5))]);
      expect(recent.months.first.month, DateTime.utc(2026, 5));
      expect(recent.months, hasLength(5));

      final old = _build([_app(1, ap, appliedAt: DateTime.utc(2024, 1, 5))]);
      expect(old.months, hasLength(Analytics.maxMonths));
      expect(old.months.first.month, DateTime.utc(2025, 10));
      expect(old.monthsTruncated, isTrue);
    });
  });

  test('median days to first response', () {
    final apps = [
      _app(1, rj, appliedAt: DateTime.utc(2026, 9, 1)),
      _app(2, sc, appliedAt: DateTime.utc(2026, 9, 1)),
      _app(3, sc, appliedAt: DateTime.utc(2026, 9, 1)),
      _app(4, ap, appliedAt: DateTime.utc(2026, 9, 1)),
    ];
    // Responses after 2, 5 and 9 days; app 4 has none.
    final history = [
      StatusChange(
        id: 1,
        applicationId: 1,
        toStatus: rj,
        changedAt: DateTime(2026, 9, 3, 9).toUtc(),
      ),
      StatusChange(
        id: 2,
        applicationId: 2,
        toStatus: sc,
        changedAt: DateTime(2026, 9, 6, 9).toUtc(),
      ),
      StatusChange(
        id: 3,
        applicationId: 3,
        toStatus: sc,
        changedAt: DateTime(2026, 9, 10, 9).toUtc(),
      ),
    ];
    expect(_build(apps, history: history).medianDaysToResponse, 5);
    expect(
      _build(apps.take(2).toList(), history: history).medianDaysToResponse,
      4, // (2 + 5) / 2 = 3.5, rounded.
    );
  });
}
