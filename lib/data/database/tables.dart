import 'package:drift/drift.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';

// Row classes are suffixed with `Row` so they never clash with the domain
// models in `lib/domain/models`. Repositories map rows to domain models.
//
// Changing anything here changes the schema: bump `schemaVersion` and add a
// migration (see CLAUDE.md → Database rules).

@DataClassName('ApplicationRow')
@TableIndex(name: 'applications_status', columns: {#status})
@TableIndex(name: 'applications_applied_at', columns: {#appliedAt})
@TableIndex(name: 'applications_deadline_at', columns: {#deadlineAt})
class Applications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get companyName => text().withLength(min: 1, max: 200)();
  TextColumn get positionTitle => text().withLength(min: 1, max: 200)();
  TextColumn get location => text().nullable()();
  TextColumn get workMode => textEnum<WorkMode>().nullable()();
  TextColumn get employmentType => textEnum<EmploymentType>().nullable()();
  IntColumn get salaryMin => integer().nullable()();
  IntColumn get salaryMax => integer().nullable()();
  TextColumn get salaryCurrency =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('IDR'))();
  TextColumn get salaryPeriod => textEnum<SalaryPeriod>().nullable()();
  TextColumn get jobUrl => text().nullable()();
  TextColumn get status => textEnum<ApplicationStatus>().withDefault(
    Constant(ApplicationStatus.saved.name),
  )();

  /// Date-only (UTC midnight). Set the first time the status leaves `saved`.
  DateTimeColumn get appliedAt => dateTime().nullable()();

  /// Date-only (UTC midnight).
  DateTimeColumn get deadlineAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<String> get customConstraints => [
    'CHECK (salary_min IS NULL OR salary_min >= 0)',
    'CHECK (salary_max IS NULL OR salary_max >= 0)',
    'CHECK (salary_min IS NULL OR salary_max IS NULL '
        'OR salary_min <= salary_max)',
  ];
}

@DataClassName('StatusHistoryRow')
@TableIndex(
  name: 'status_history_application',
  columns: {#applicationId, #changedAt},
)
class StatusHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get applicationId =>
      integer().references(Applications, #id, onDelete: KeyAction.cascade)();

  /// `NULL` for the initial status recorded on creation.
  TextColumn get fromStatus => textEnum<ApplicationStatus>().nullable()();
  TextColumn get toStatus => textEnum<ApplicationStatus>()();
  DateTimeColumn get changedAt => dateTime()();
}

@DataClassName('InterviewRow')
@TableIndex(name: 'interviews_application', columns: {#applicationId})
@TableIndex(name: 'interviews_scheduled_at', columns: {#scheduledAt})
class Interviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get applicationId =>
      integer().references(Applications, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get format => textEnum<InterviewFormat>()();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get durationMinutes => integer().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get interviewer => text().nullable()();
  TextColumn get outcome => textEnum<InterviewOutcome>().withDefault(
    Constant(InterviewOutcome.pending.name),
  )();
  TextColumn get summary => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<String> get customConstraints => [
    'CHECK (duration_minutes IS NULL OR duration_minutes > 0)',
  ];
}

@DataClassName('ChecklistItemRow')
@TableIndex(
  name: 'checklist_items_application',
  columns: {#applicationId, #position},
)
@TableIndex(name: 'checklist_items_interview', columns: {#interviewId})
class ChecklistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get applicationId =>
      integer().references(Applications, #id, onDelete: KeyAction.cascade)();

  /// Optional: the interview this task prepares for.
  IntColumn get interviewId => integer().nullable().references(
    Interviews,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get position => integer()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('NoteRow')
@TableIndex(name: 'notes_application', columns: {#applicationId})
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get applicationId =>
      integer().references(Applications, #id, onDelete: KeyAction.cascade)();
  TextColumn get content => text().withLength(min: 1)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
