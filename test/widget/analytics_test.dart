import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/data/seed/demo_data_seeder.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/shared/widgets/stat_tile.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

/// Tall enough to build every analytics section without scrolling.
const _tallPhone = Size(390, 3200);

Future<void> seedDemo(AppDatabase db) =>
    DemoDataSeeder(db, clock: FakeClock.standard().call).seed();

Future<void> openAnalytics(
  WidgetTester tester,
  Future<void> Function(AppDatabase) seed,
) async {
  await tester.pumpApp(size: _tallPhone, seed: seed);
  await tester.tapTab('Analytics');
}

StatTile tile(WidgetTester tester, String label) =>
    tester.widget<StatTile>(find.widgetWithText(StatTile, label));

void main() {
  testWidgets('empty analytics offers to add an application', (tester) async {
    await tester.pumpApp();
    await tester.tapTab('Analytics');
    expect(find.text('No applications yet'), findsOneWidget);
  });

  testWidgets('all time: rates follow the metric definitions', (tester) async {
    final semantics = tester.ensureSemantics();
    await openAnalytics(tester, seedDemo);

    expect(tile(tester, 'Sent').value, '11');
    expect(tile(tester, 'Response rate').value, '73%');
    expect(tile(tester, 'Response rate').caption, '8 of 11 sent');
    expect(tile(tester, 'Interview rate').value, '36%');
    expect(tile(tester, 'Interview rate').caption, '4 of 11 sent');
    expect(tile(tester, 'Offer rate').value, '9%');

    // Funnel rows read their numbers to screen readers (the Card merges its
    // children into one node, so match within the card's label).
    expect(
      find.bySemanticsLabel(RegExp('Response: 8 of 11, 73%')),
      findsOneWidget,
    );
    expect(
      find.text('Typical wait for a first response: 8 days (median)'),
      findsOneWidget,
    );

    // Chart description and table view (newest month first).
    expect(
      find.bySemanticsLabel(
        RegExp('Applications per month. .*Aug: 5 sent, 3 with a response'),
      ),
      findsOneWidget,
    );
    expect(find.text('Sep 2026'), findsOneWidget);
    expect(find.text('Jun 2026'), findsOneWidget);
    expect(find.text('May 2026'), findsNothing);
    semantics.dispose();
  });

  testWidgets('switching to 3 months recomputes the report', (tester) async {
    await openAnalytics(tester, seedDemo);

    await tester.tap(find.text('3 months'));
    await tester.pumpAndSettle();

    expect(tile(tester, 'Sent').value, '10');
    expect(tile(tester, 'Response rate').value, '70%');
    expect(tile(tester, 'Interview rate').value, '40%');
    expect(tile(tester, 'Offer rate').value, '10%');
    expect(find.text('Jun 2026'), findsNothing);
  });

  testWidgets('a period with nothing sent explains why', (tester) async {
    await openAnalytics(tester, (db) async {
      await ApplicationRepository(db, clock: FakeClock.standard().call).create(
        ApplicationDraft(
          companyName: 'Old Co',
          positionTitle: 'Developer',
          status: ApplicationStatus.rejected,
          appliedAt: DateTime.utc(2025, 1, 10),
        ),
      );
    });

    await tester.tap(find.text('3 months'));
    await tester.pumpAndSettle();

    expect(find.text('No applications sent in this period'), findsOneWidget);
    expect(find.byType(StatTile), findsNothing);
  });
}
