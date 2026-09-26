import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/seed/demo_data_seeder.dart';
import 'package:job_application_tracker/features/applications/application_detail_screen.dart';
import 'package:job_application_tracker/features/dashboard/dashboard_screen.dart';
import 'package:job_application_tracker/shared/widgets/stat_tile.dart';
import 'package:job_application_tracker/shared/widgets/status_breakdown.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// Tall enough to build every dashboard section without scrolling.
const _tallPhone = Size(390, 2600);

Future<void> seedDemo(AppDatabase db) =>
    DemoDataSeeder(db, clock: FakeClock.standard().call).seed();

void main() {
  testWidgets('empty dashboard offers to add an application', (tester) async {
    await tester.pumpApp();

    expect(find.text('No applications yet'), findsOneWidget);
    expect(find.text('Add application'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('summarises the demo data', (tester) async {
    await tester.pumpApp(size: _tallPhone, seed: seedDemo);

    // Intro (FakeClock: Saturday 26 September 2026, 10:30).
    expect(find.text('Saturday, September 26'), findsOneWidget);
    expect(find.text('Good morning'), findsOneWidget);
    expect(
      find.text('1 interview and 2 deadlines in the next 7 days.'),
      findsOneWidget,
    );

    // Stat tiles.
    String tileValue(String label) =>
        tester.widget<StatTile>(find.widgetWithText(StatTile, label)).value;
    expect(tileValue('Active'), '8');
    expect(tileValue('This month'), '3');
    expect(tileValue('Interviews'), '1');
    expect(tileValue('Offers'), '1');
    expect(find.text('of 13 applications'), findsOneWidget);

    // Up next: the interview first, then deadlines soonest first.
    expect(find.text('User Interview'), findsOneWidget);
    expect(find.textContaining('Rimba Logistics · Monday'), findsOneWidget);
    expect(find.text('Samudra Commerce · Due in 3 days'), findsOneWidget);
    expect(find.text('Tunas Studio · Due in 6 days'), findsOneWidget);

    // Pipeline rows cover all 13 applications.
    for (final label in [
      'Saved',
      'Applied',
      'Screening',
      'Technical Test',
      'Offer',
      'Rejected',
      'Withdrawn',
    ]) {
      expect(
        find.descendant(
          of: find.byType(StatusBreakdown),
          matching: find.text(label),
        ),
        findsOneWidget,
        reason: label,
      );
    }

    // Recent activity, newest first.
    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('Data Analyst · Mandala Data'), findsOneWidget);
    expect(find.text('2d ago'), findsOneWidget);
  });

  testWidgets('opens an application from Up next and returns', (tester) async {
    await tester.pumpApp(size: _tallPhone, seed: seedDemo);

    await tester.tap(find.text('User Interview'));
    await tester.pumpAndSettle();
    expect(find.byType(ApplicationDetailScreen), findsOneWidget);
    expect(find.text('Backend Developer'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Good morning'), findsOneWidget);
  });
}
