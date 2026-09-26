import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/application.dart';

import 'test_database.dart';

/// Four applications covering search, filter and sort edge cases.
/// Created in this order, so "recently updated" order is D, C, B, A.
///
/// | | Company | Position | Location | Mode | Type | Status | Applied | Deadline |
/// |-|-|-|-|-|-|-|-|-|
/// | A | Arunika Digital | Flutter Developer | Jakarta | hybrid | full-time | interview | Sep 1 | – |
/// | B | Sagara Labs | Frontend Developer | Bandung | remote | full-time | applied | Sep 10 | Oct 1 |
/// | C | kopi kode | Web Developer | Yogyakarta | on-site | contract | saved | – | Sep 28 |
/// | D | 100% Remote Co | Data_Analyst | – | remote | internship | rejected | Aug 20 | – |
Future<void> seedQueryFixtures(AppDatabase db) async {
  final clock = FakeClock.standard();
  final repo = ApplicationRepository(db, clock: clock.call);

  final drafts = [
    ApplicationDraft(
      companyName: 'Arunika Digital',
      positionTitle: 'Flutter Developer',
      location: 'Jakarta',
      workMode: WorkMode.hybrid,
      employmentType: EmploymentType.fullTime,
      status: ApplicationStatus.interview,
      appliedAt: DateTime.utc(2026, 9, 1),
    ),
    ApplicationDraft(
      companyName: 'Sagara Labs',
      positionTitle: 'Frontend Developer',
      location: 'Bandung',
      workMode: WorkMode.remote,
      employmentType: EmploymentType.fullTime,
      status: ApplicationStatus.applied,
      appliedAt: DateTime.utc(2026, 9, 10),
      deadlineAt: DateTime.utc(2026, 10, 1),
    ),
    ApplicationDraft(
      companyName: 'kopi kode',
      positionTitle: 'Web Developer',
      location: 'Yogyakarta',
      workMode: WorkMode.onsite,
      employmentType: EmploymentType.contract,
      deadlineAt: DateTime.utc(2026, 9, 28),
    ),
    ApplicationDraft(
      companyName: '100% Remote Co',
      positionTitle: 'Data_Analyst',
      workMode: WorkMode.remote,
      employmentType: EmploymentType.internship,
      status: ApplicationStatus.rejected,
      appliedAt: DateTime.utc(2026, 8, 20),
    ),
  ];

  for (final draft in drafts) {
    await repo.create(draft);
    clock.advance(const Duration(minutes: 1));
  }
}
