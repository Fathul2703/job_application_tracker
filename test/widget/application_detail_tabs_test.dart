import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/repositories/checklist_repository.dart';
import 'package:job_application_tracker/data/repositories/interview_repository.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/interview.dart';
import 'package:job_application_tracker/features/applications/widgets/application_card.dart';
import 'package:job_application_tracker/features/interviews/interview_form_screen.dart';
import 'package:job_application_tracker/features/interviews/widgets/interview_card.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// One saved application, optionally with a past HR interview and a
/// checklist item.
Future<void> Function(AppDatabase) seed({
  bool withInterview = false,
  bool withTask = false,
}) {
  return (db) async {
    final clock = FakeClock.standard();
    final appId = await ApplicationRepository(db, clock: clock.call).create(
      const ApplicationDraft(
        companyName: 'Rimba Logistics',
        positionTitle: 'Backend Developer',
        status: ApplicationStatus.applied,
      ),
    );
    if (withInterview) {
      await InterviewRepository(db, clock: clock.call).create(
        appId,
        InterviewDraft(
          title: 'HR Interview',
          format: InterviewFormat.video,
          scheduledAt: DateTime(2026, 9, 20, 10),
        ),
      );
    }
    if (withTask) {
      await ChecklistRepository(
        db,
        clock: clock.call,
      ).add(appId, 'Review REST API design');
    }
  };
}

Future<void> openTab(WidgetTester tester, String tab) async {
  await tester.tapTab('Applications');
  await tester.tap(find.byType(ApplicationCard).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(tab));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the four detail tabs', (tester) async {
    await tester.pumpApp(seed: seed());
    await openTab(tester, 'Overview');

    for (final tab in ['Overview', 'Interviews', 'Checklist', 'Notes']) {
      expect(find.text(tab), findsOneWidget);
    }
  });

  group('Interviews', () {
    testWidgets('adds an interview and offers to move the status', (
      tester,
    ) async {
      final db = await tester.pumpApp(seed: seed());
      await openTab(tester, 'Interviews');
      expect(find.text('No interviews yet'), findsOneWidget);

      await tester.tap(find.text('Add interview'));
      await tester.pumpAndSettle();
      expect(find.byType(InterviewFormScreen), findsOneWidget);

      // Title suggestions fill the field.
      await tester.tap(find.widgetWithText(ActionChip, 'User Interview'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(InterviewCard), findsOneWidget);
      expect(find.text('User Interview'), findsOneWidget);
      // intl puts a narrow no-break space before "AM", so match loosely.
      expect(
        find.textContaining(RegExp(r'^Tomorrow · 10:00\sAM · 60 min$')),
        findsOneWidget,
      );
      expect(find.text('Upcoming'), findsOneWidget);

      await tester.tap(find.text('Move to Interview'));
      await tester.pumpAndSettle();
      final app = await ApplicationRepository(db).getById(1);
      expect(app!.status, ApplicationStatus.interview);
    });

    testWidgets('edits the outcome and deletes an interview', (tester) async {
      await tester.pumpApp(seed: seed(withInterview: true));
      await openTab(tester, 'Interviews');
      expect(find.text('Past'), findsOneWidget);

      await tester.tap(find.byType(InterviewCard));
      await tester.pumpAndSettle();
      expect(find.text('Edit interview'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.widgetWithText(ChoiceChip, 'Passed'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.widgetWithText(ChoiceChip, 'Passed'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(InterviewCard),
          matching: find.text('Passed'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byType(InterviewCard));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete interview'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.text('No interviews yet'), findsOneWidget);
    });
  });

  group('Checklist', () {
    testWidgets('adds, completes, renames and deletes tasks', (tester) async {
      await tester.pumpApp(seed: seed());
      await openTab(tester, 'Checklist');

      await tester.tap(find.widgetWithText(ActionChip, 'Research the company'));
      await tester.pumpAndSettle();
      expect(find.text('0 of 1 done'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Add a task'),
        'Prepare STAR stories',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('0 of 2 done'), findsOneWidget);

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();
      expect(find.text('1 of 2 done'), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget); // Tab count.

      await tester.tap(find.byTooltip('Task options').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(TextField),
        ),
        'Prepare three STAR stories',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      expect(find.text('Prepare three STAR stories'), findsOneWidget);

      await tester.tap(find.byTooltip('Task options').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Prepare three STAR stories'), findsNothing);
      expect(find.text('1 of 1 done'), findsOneWidget);
    });

    testWidgets('links a task to an interview', (tester) async {
      await tester.pumpApp(seed: seed(withInterview: true, withTask: true));
      await openTab(tester, 'Checklist');

      await tester.tap(find.byTooltip('Task options'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Link to interview'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(SimpleDialogOption, 'HR Interview'));
      await tester.pumpAndSettle();
      expect(find.text('For HR Interview'), findsOneWidget);

      await tester.tap(find.text('Interviews'));
      await tester.pumpAndSettle();
      expect(find.text('0 of 1 prep tasks done'), findsOneWidget);
    });
  });

  testWidgets('adds, edits and deletes notes', (tester) async {
    final clock = FakeClock.standard();
    await tester.pumpApp(clock: clock, seed: seed());
    await openTab(tester, 'Notes');
    expect(find.text('No notes yet'), findsOneWidget);

    await tester.tap(find.text('Add note'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      ),
      'Recruiter: Sinta',
    );
    await tester.pump(); // Enables Save.
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.text('Recruiter: Sinta'), findsOneWidget);
    expect(find.textContaining('Edited'), findsNothing);

    clock.advance(const Duration(hours: 1));
    await tester.tap(find.text('Recruiter: Sinta'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      ),
      'Recruiter: Sinta (HR lead)',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(find.text('Recruiter: Sinta (HR lead)'), findsOneWidget);
    expect(find.textContaining('Edited'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete note'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('No notes yet'), findsOneWidget);
  });
}
