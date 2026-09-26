import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/application_detail_screen.dart';
import 'package:job_application_tracker/features/applications/application_form_screen.dart';
import 'package:job_application_tracker/features/applications/detail/overview_tab.dart';
import 'package:job_application_tracker/features/applications/widgets/application_card.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

Future<void> seedOne(AppDatabase db) async {
  await ApplicationRepository(db, clock: FakeClock.standard().call).create(
    const ApplicationDraft(
      companyName: 'Arunika Digital',
      positionTitle: 'Flutter Developer',
      location: 'Jakarta',
      salaryMin: 12000000,
      salaryMax: 16000000,
    ),
  );
}

Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<void> openFirstApplication(WidgetTester tester) async {
  await tester.tapTab('Applications');
  await tester.tap(find.byType(ApplicationCard).first);
  await tester.pumpAndSettle();
}

void main() {
  group('Applications list', () {
    testWidgets('shows an empty state with add and demo data actions', (
      tester,
    ) async {
      await tester.pumpApp();
      await tester.tapTab('Applications');

      expect(find.text('No applications yet'), findsOneWidget);
      expect(find.text('Add application'), findsOneWidget);
      // Tests run in debug mode, where the demo action is available.
      expect(find.text('Load demo data'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('loads demo data from the empty state', (tester) async {
      await tester.pumpApp();
      await tester.tapTab('Applications');

      await tester.tap(find.text('Load demo data'));
      await tester.pumpAndSettle();

      expect(find.byType(ApplicationCard), findsWidgets);
      expect(find.textContaining('13 applications'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('cards show position, company, meta and status', (
      tester,
    ) async {
      await tester.pumpApp(seed: seedOne);
      await tester.tapTab('Applications');

      expect(find.text('Flutter Developer'), findsOneWidget);
      expect(find.text('Arunika Digital'), findsOneWidget);
      expect(find.text('Jakarta · Rp 12M – 16M'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Saved Sep 26'), findsOneWidget);
    });
  });

  group('Create', () {
    testWidgets('saves a new application and opens its detail', (tester) async {
      await tester.pumpApp();
      await tester.tapTab('Applications');
      await tester.tap(find.text('Add application'));
      await tester.pumpAndSettle();

      expect(find.text('New application'), findsOneWidget);
      await tester.enterText(field('Company *'), '  Sagara Labs ');
      await tester.enterText(field('Position *'), 'Frontend Developer');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(ApplicationDetailScreen), findsOneWidget);
      expect(find.text('Frontend Developer'), findsOneWidget);
      expect(find.text('Sagara Labs'), findsOneWidget);
      expect(find.text('Added as Saved'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ApplicationCard), findsOneWidget);
    });

    testWidgets('shows validation errors and does not save', (tester) async {
      final db = await tester.pumpApp();
      await tester.tapTab('Applications');
      await tester.tap(find.text('Add application'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Company is required.'), findsOneWidget);
      expect(find.text('Position is required.'), findsOneWidget);
      expect(find.byType(ApplicationFormScreen), findsOneWidget);
      expect(await db.select(db.applications).get(), isEmpty);
    });

    testWidgets('formats salary input and validates the range', (tester) async {
      await tester.pumpApp();
      await tester.tapTab('Applications');
      await tester.tap(find.text('Add application'));
      await tester.pumpAndSettle();

      await tester.enterText(field('Company *'), 'Acme');
      await tester.enterText(field('Position *'), 'Developer');
      await tester.scrollUntilVisible(
        field('Minimum'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(field('Minimum'), '16000000');
      await tester.enterText(field('Maximum'), '12000000');
      await tester.pump();

      expect(find.text('16,000,000'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(
        find.text('Minimum salary cannot exceed maximum salary.'),
        findsOneWidget,
      );
    });

    testWidgets('asks before discarding unsaved changes', (tester) async {
      await tester.pumpApp();
      await tester.tapTab('Applications');
      await tester.tap(find.text('Add application'));
      await tester.pumpAndSettle();

      await tester.enterText(field('Company *'), 'Acme');
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Discard changes?'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(ApplicationFormScreen), findsOneWidget);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();
      expect(find.byType(ApplicationFormScreen), findsNothing);
    });

    testWidgets('closes immediately when nothing changed', (tester) async {
      await tester.pumpApp();
      await tester.tapTab('Applications');
      await tester.tap(find.text('Add application'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Discard changes?'), findsNothing);
      expect(find.byType(ApplicationFormScreen), findsNothing);
    });
  });

  group('Detail', () {
    testWidgets('changes status and records it in the timeline', (
      tester,
    ) async {
      final db = await tester.pumpApp(seed: seedOne);
      await openFirstApplication(tester);

      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      expect(find.text('Change status'), findsOneWidget);

      await tester.tap(find.text('Interview rounds in progress'));
      await tester.pumpAndSettle();

      expect(find.text('Moved to Interview'), findsOneWidget); // snackbar
      expect(find.text('Interview rounds in progress'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Added as Saved'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(OverviewTab),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      // Timeline entry (newest first) plus the snackbar.
      expect(find.text('Moved to Interview'), findsNWidgets(2));

      final repo = ApplicationRepository(db);
      final app = await repo.getById(1);
      expect(app!.status, ApplicationStatus.interview);
      expect(app.appliedAt, DateTime.utc(2026, 9, 26));
      // Plain queries only: stream queries rely on timers that don't run
      // inside testWidgets' fake async zone.
      expect(await db.select(db.statusHistory).get(), hasLength(2));
    });

    testWidgets('edits an application and returns to the detail', (
      tester,
    ) async {
      await tester.pumpApp(seed: seedOne);
      await openFirstApplication(tester);

      await tester.tap(find.byTooltip('Edit'));
      await tester.pumpAndSettle();
      expect(find.text('Edit application'), findsOneWidget);
      // Pre-filled from the saved application.
      expect(find.text('Flutter Developer'), findsOneWidget);
      expect(find.text('Jakarta'), findsOneWidget);

      await tester.enterText(field('Position *'), 'Senior Flutter Developer');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(ApplicationFormScreen), findsNothing);
      expect(find.byType(ApplicationDetailScreen), findsOneWidget);
      expect(find.text('Senior Flutter Developer'), findsOneWidget);
    });

    testWidgets('deletes an application after confirmation', (tester) async {
      final db = await tester.pumpApp(seed: seedOne);
      await openFirstApplication(tester);

      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Delete application?'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.byType(ApplicationDetailScreen), findsNothing);
      expect(find.text('No applications yet'), findsOneWidget);
      expect(find.text('Application deleted'), findsOneWidget);
      expect(await db.select(db.applications).get(), isEmpty);
    });

    testWidgets('shows not found for an unknown id', (tester) async {
      await tester.pumpApp();
      GoRouter.of(tester.element(find.byType(Scaffold).first))
          .go('/applications/999');
      await tester.pumpAndSettle();

      expect(find.text('Application not found'), findsOneWidget);
    });
  });
}
