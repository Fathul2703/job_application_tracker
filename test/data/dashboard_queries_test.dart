import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/repositories/interview_repository.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/interview.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late ApplicationRepository applications;
  late InterviewRepository interviews;

  setUp(() {
    db = createTestDatabase();
    clock = FakeClock.standard();
    applications = ApplicationRepository(db, clock: clock.call);
    interviews = InterviewRepository(db, clock: clock.call);
  });

  InterviewDraft at(
    DateTime when, {
    String title = 'Interview',
    InterviewOutcome outcome = InterviewOutcome.pending,
  }) => InterviewDraft(
    title: title,
    format: InterviewFormat.video,
    scheduledAt: when,
    outcome: outcome,
  );

  test('watchUpcoming: range, order, company and no cancelled', () async {
    final a = await applications.create(
      const ApplicationDraft(companyName: 'Arunika', positionTitle: 'Flutter'),
    );
    final b = await applications.create(
      const ApplicationDraft(companyName: 'Sagara', positionTitle: 'Frontend'),
    );
    await interviews.create(a, at(DateTime(2026, 9, 25, 9), title: 'Past'));
    await interviews.create(b, at(DateTime(2026, 9, 30, 9), title: 'Later'));
    await interviews.create(a, at(DateTime(2026, 9, 27, 9), title: 'Soon'));
    await interviews.create(
      a,
      at(
        DateTime(2026, 9, 28, 9),
        title: 'Cancelled',
        outcome: InterviewOutcome.cancelled,
      ),
    );
    await interviews.create(a, at(DateTime(2026, 10, 20), title: 'Far'));

    final upcoming = await interviews
        .watchUpcoming(
          from: DateTime(2026, 9, 26),
          until: DateTime(2026, 10, 4),
        )
        .first;

    expect(upcoming.map((u) => u.interview.title), ['Soon', 'Later']);
    expect(upcoming.map((u) => u.companyName), ['Arunika', 'Sagara']);
    expect(upcoming.first.positionTitle, 'Flutter');
  });

  test('watchRecentActivity: newest first, limited, with company', () async {
    final id = await applications.create(
      const ApplicationDraft(companyName: 'Rimba', positionTitle: 'Backend'),
    );
    for (final status in [
      ApplicationStatus.applied,
      ApplicationStatus.screening,
      ApplicationStatus.interview,
    ]) {
      clock.advance(const Duration(days: 1));
      await applications.changeStatus(id, status);
    }

    final activity = await applications.watchRecentActivity(limit: 3).first;

    expect(activity.map((a) => a.change.toStatus), [
      ApplicationStatus.interview,
      ApplicationStatus.screening,
      ApplicationStatus.applied,
    ]);
    expect(activity.first.companyName, 'Rimba');
    expect(activity.first.positionTitle, 'Backend');
  });
}
