import 'package:drift/drift.dart';
import 'package:job_application_tracker/core/utils/clock.dart';
import 'package:job_application_tracker/core/utils/date_only.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';

/// Fills an empty database with realistic, fictional demo data spread over
/// the last ~3.5 months, for screenshots and trying the app out.
///
/// Writes rows directly (not through repositories) so it can back-date
/// status history. Intended for debug builds only.
class DemoDataSeeder {
  DemoDataSeeder(this._db, {this._clock = DateTime.now});

  final AppDatabase _db;
  final Clock _clock;

  /// Seeds only when there are no applications. Returns whether it seeded.
  Future<bool> seedIfEmpty() async {
    final count = await _db.applications.count().getSingle();
    if (count > 0) return false;
    await seed();
    return true;
  }

  Future<void> seed() {
    final now = _clock();
    DateTime daysAgo(int days) => now.subtract(Duration(days: days)).toUtc();

    return _db.transaction(() async {
      for (final demo in _demoApplications) {
        final steps = demo.path;
        final firstSubmitted = steps
            .where((s) => s.status != ApplicationStatus.saved)
            .firstOrNull;

        final applicationId = await _db
            .into(_db.applications)
            .insert(
              ApplicationsCompanion.insert(
                companyName: demo.company,
                positionTitle: demo.position,
                location: Value(demo.location),
                workMode: Value(demo.workMode),
                employmentType: Value(demo.type),
                salaryMin: Value(demo.salary?.$1),
                salaryMax: Value(demo.salary?.$2),
                salaryPeriod: Value(
                  demo.salary == null ? null : SalaryPeriod.monthly,
                ),
                jobUrl: Value(demo.jobUrl),
                status: Value(steps.last.status),
                appliedAt: Value(
                  firstSubmitted == null
                      ? null
                      : now
                            .subtract(Duration(days: firstSubmitted.daysAgo))
                            .toDateOnly(),
                ),
                deadlineAt: Value(
                  demo.deadlineInDays == null
                      ? null
                      : now
                            .add(Duration(days: demo.deadlineInDays!))
                            .toDateOnly(),
                ),
                createdAt: daysAgo(steps.first.daysAgo),
                updatedAt: daysAgo(steps.last.daysAgo),
              ),
            );

        ApplicationStatus? previous;
        for (final step in steps) {
          await _db
              .into(_db.statusHistory)
              .insert(
                StatusHistoryCompanion.insert(
                  applicationId: applicationId,
                  fromStatus: Value(previous),
                  toStatus: step.status,
                  changedAt: daysAgo(step.daysAgo),
                ),
              );
          previous = step.status;
        }

        int? upcomingInterviewId;
        for (final interview in demo.interviews) {
          // 10:00 local on the interview day.
          final scheduledAt = DateTime(
            now.year,
            now.month,
            now.day + interview.inDays,
            10,
          ).toUtc();
          final id = await _db
              .into(_db.interviews)
              .insert(
                InterviewsCompanion.insert(
                  applicationId: applicationId,
                  title: interview.title,
                  format: interview.format,
                  scheduledAt: scheduledAt,
                  durationMinutes: const Value(60),
                  interviewer: Value(interview.interviewer),
                  outcome: Value(interview.outcome),
                  createdAt: daysAgo(steps.last.daysAgo),
                  updatedAt: daysAgo(steps.last.daysAgo),
                ),
              );
          if (interview.inDays > 0) upcomingInterviewId = id;
        }

        for (final (index, (title, done)) in demo.checklist.indexed) {
          await _db
              .into(_db.checklistItems)
              .insert(
                ChecklistItemsCompanion.insert(
                  applicationId: applicationId,
                  interviewId: Value(upcomingInterviewId),
                  title: title,
                  isDone: Value(done),
                  position: index,
                  completedAt: Value(done ? daysAgo(1) : null),
                  createdAt: daysAgo(steps.last.daysAgo),
                ),
              );
        }

        for (final note in demo.notes) {
          await _db
              .into(_db.notes)
              .insert(
                NotesCompanion.insert(
                  applicationId: applicationId,
                  content: note,
                  createdAt: daysAgo(steps.last.daysAgo),
                  updatedAt: daysAgo(steps.last.daysAgo),
                ),
              );
        }
      }
    });
  }
}

typedef _Step = ({ApplicationStatus status, int daysAgo});

/// `inDays` is relative to today: negative = past, positive = upcoming.
typedef _DemoInterview = ({
  String title,
  InterviewFormat format,
  int inDays,
  InterviewOutcome outcome,
  String? interviewer,
});

class _DemoApplication {
  const _DemoApplication({
    required this.company,
    required this.position,
    required this.location,
    required this.workMode,
    required this.type,
    required this.path,
    this.salary,
    this.jobUrl,
    this.deadlineInDays,
    this.interviews = const [],
    this.checklist = const [],
    this.notes = const [],
  });

  final String company;
  final String position;
  final String location;
  final WorkMode workMode;
  final EmploymentType type;

  /// Status timeline, oldest first. The last step is the current status.
  final List<_Step> path;

  /// Monthly IDR range.
  final (int, int)? salary;
  final String? jobUrl;
  final int? deadlineInDays;
  final List<_DemoInterview> interviews;
  final List<(String, bool)> checklist;
  final List<String> notes;
}

const _s = ApplicationStatus.saved;
const _ap = ApplicationStatus.applied;
const _sc = ApplicationStatus.screening;
const _iv = ApplicationStatus.interview;
const _tt = ApplicationStatus.technicalTest;
const _of = ApplicationStatus.offer;
const _rj = ApplicationStatus.rejected;
const _wd = ApplicationStatus.withdrawn;

// All companies are fictional.
const _demoApplications = <_DemoApplication>[
  _DemoApplication(
    company: 'Garuda Retail Group',
    position: 'Web Developer',
    location: 'Jakarta',
    workMode: WorkMode.onsite,
    type: EmploymentType.fullTime,
    salary: (8000000, 11000000),
    path: [(status: _ap, daysAgo: 104), (status: _rj, daysAgo: 88)],
  ),
  _DemoApplication(
    company: 'Arunika Digital',
    position: 'Flutter Developer',
    location: 'Jakarta',
    workMode: WorkMode.hybrid,
    type: EmploymentType.fullTime,
    salary: (12000000, 16000000),
    jobUrl: 'https://example.com/careers/flutter-developer',
    path: [
      (status: _s, daysAgo: 64),
      (status: _ap, daysAgo: 62),
      (status: _sc, daysAgo: 54),
      (status: _iv, daysAgo: 47),
      (status: _tt, daysAgo: 38),
      (status: _of, daysAgo: 20),
    ],
    interviews: [
      (
        title: 'HR Interview',
        format: InterviewFormat.video,
        inDays: -46,
        outcome: InterviewOutcome.passed,
        interviewer: 'Talent Acquisition',
      ),
      (
        title: 'Technical Interview',
        format: InterviewFormat.onsite,
        inDays: -30,
        outcome: InterviewOutcome.passed,
        interviewer: 'Mobile Lead',
      ),
    ],
    notes: ['Offer letter received. Reply before the end of the month.'],
  ),
  _DemoApplication(
    company: 'Sagara Labs',
    position: 'Frontend Developer',
    location: 'Bandung',
    workMode: WorkMode.remote,
    type: EmploymentType.fullTime,
    salary: (10000000, 14000000),
    path: [
      (status: _ap, daysAgo: 57),
      (status: _sc, daysAgo: 49),
      (status: _rj, daysAgo: 41),
    ],
  ),
  _DemoApplication(
    company: 'Kopi Kode',
    position: 'Web Developer',
    location: 'Yogyakarta',
    workMode: WorkMode.onsite,
    type: EmploymentType.fullTime,
    salary: (7000000, 9000000),
    path: [(status: _ap, daysAgo: 51), (status: _rj, daysAgo: 36)],
  ),
  _DemoApplication(
    company: 'Nusa Fintech',
    position: 'Data Analyst',
    location: 'Jakarta',
    workMode: WorkMode.hybrid,
    type: EmploymentType.fullTime,
    salary: (11000000, 15000000),
    path: [
      (status: _ap, daysAgo: 42),
      (status: _sc, daysAgo: 35),
      (status: _iv, daysAgo: 28),
      (status: _rj, daysAgo: 18),
    ],
    interviews: [
      (
        title: 'HR Interview',
        format: InterviewFormat.phone,
        inDays: -27,
        outcome: InterviewOutcome.passed,
        interviewer: null,
      ),
      (
        title: 'User Interview',
        format: InterviewFormat.video,
        inDays: -21,
        outcome: InterviewOutcome.failed,
        interviewer: 'Head of Data',
      ),
    ],
    notes: ['Feedback: strengthen SQL window functions and A/B testing.'],
  ),
  _DemoApplication(
    company: 'Lentera Health',
    position: 'Mobile Developer',
    location: 'Surabaya',
    workMode: WorkMode.onsite,
    type: EmploymentType.contract,
    salary: (9000000, 12000000),
    path: [(status: _ap, daysAgo: 38)],
  ),
  _DemoApplication(
    company: 'Rimba Logistics',
    position: 'Backend Developer',
    location: 'Jakarta',
    workMode: WorkMode.onsite,
    type: EmploymentType.fullTime,
    salary: (13000000, 18000000),
    jobUrl: 'https://example.com/jobs/backend-developer',
    path: [
      (status: _ap, daysAgo: 30),
      (status: _sc, daysAgo: 24),
      (status: _iv, daysAgo: 12),
    ],
    interviews: [
      (
        title: 'HR Interview',
        format: InterviewFormat.video,
        inDays: -10,
        outcome: InterviewOutcome.passed,
        interviewer: 'People Team',
      ),
      (
        title: 'User Interview',
        format: InterviewFormat.onsite,
        inDays: 2,
        outcome: InterviewOutcome.pending,
        interviewer: 'Engineering Manager',
      ),
    ],
    checklist: [
      ('Research the company and its products', true),
      ('Review REST API design and database indexing', false),
      ('Prepare two STAR stories about past projects', false),
      ('Prepare questions for the interviewer', false),
    ],
    notes: [
      'Tech stack: Laravel, PostgreSQL, Redis.',
      'Recruiter mentioned the team is expanding next quarter.',
    ],
  ),
  _DemoApplication(
    company: 'Pelita Edu',
    position: 'Junior Data Engineer',
    location: 'Jakarta',
    workMode: WorkMode.remote,
    type: EmploymentType.fullTime,
    path: [(status: _ap, daysAgo: 27), (status: _wd, daysAgo: 15)],
    notes: ['Withdrew: role required relocation after probation.'],
  ),
  _DemoApplication(
    company: 'Samudra Commerce',
    position: 'Full-stack Developer',
    location: 'Jakarta',
    workMode: WorkMode.hybrid,
    type: EmploymentType.fullTime,
    salary: (12000000, 17000000),
    deadlineInDays: 3,
    path: [
      (status: _ap, daysAgo: 20),
      (status: _sc, daysAgo: 14),
      (status: _tt, daysAgo: 6),
    ],
    checklist: [
      ('Read the take-home brief', true),
      ('Build the API and write tests', false),
      ('Write the README and submit', false),
    ],
  ),
  _DemoApplication(
    company: 'Bumi Analytics',
    position: 'BI Analyst',
    location: 'Bandung',
    workMode: WorkMode.hybrid,
    type: EmploymentType.fullTime,
    salary: (9000000, 12000000),
    path: [(status: _ap, daysAgo: 16)],
  ),
  _DemoApplication(
    company: 'Cakra Cloud',
    position: 'Software Engineer Intern',
    location: 'Jakarta',
    workMode: WorkMode.onsite,
    type: EmploymentType.internship,
    salary: (4000000, 5000000),
    path: [(status: _ap, daysAgo: 9), (status: _sc, daysAgo: 4)],
  ),
  _DemoApplication(
    company: 'Tunas Studio',
    position: 'Flutter Developer',
    location: 'Remote',
    workMode: WorkMode.remote,
    type: EmploymentType.freelance,
    deadlineInDays: 6,
    path: [(status: _s, daysAgo: 5)],
  ),
  _DemoApplication(
    company: 'Mandala Data',
    position: 'Data Analyst',
    location: 'Jakarta',
    workMode: WorkMode.hybrid,
    type: EmploymentType.fullTime,
    salary: (10000000, 13000000),
    deadlineInDays: 12,
    path: [(status: _s, daysAgo: 2)],
  ),
];
