import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/seed/demo_data_seeder.dart';
import 'package:job_application_tracker/features/applications/widgets/application_card.dart';
import 'package:job_application_tracker/shared/widgets/content_app_bar.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

Future<void> seedDemo(AppDatabase db) =>
    DemoDataSeeder(db, clock: FakeClock.standard().call).seed();

Finder appBarTitle(String text) =>
    find.descendant(of: find.byType(AppBar), matching: find.text(text));

void main() {
  test('inset centres the content width and is zero on phones', () {
    expect(ContentAppBar.insetFor(390), 0);
    expect(ContentAppBar.insetFor(AppLayout.maxContentWidth), 0);
    expect(
      ContentAppBar.insetFor(1000),
      (1000 - AppLayout.maxContentWidth) / 2,
    );
  });

  for (final (name, size) in [
    ('phone', TestSizes.phone),
    ('tablet landscape', TestSizes.tabletLandscape),
  ]) {
    testWidgets('title lines up with page content on $name', (tester) async {
      await tester.pumpApp(size: size, seed: seedDemo);

      final titleLeft = tester.getTopLeft(appBarTitle('Dashboard')).dx;
      final contentLeft = tester.getTopLeft(find.text('Good morning')).dx;
      expect(titleLeft, moreOrLessEquals(contentLeft, epsilon: 1));
    });
  }

  testWidgets('back button and actions stay within the content column', (
    tester,
  ) async {
    await tester.pumpApp(size: TestSizes.tabletLandscape, seed: seedDemo);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationRail),
        matching: find.text('Applications'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ApplicationCard).first);
    await tester.pumpAndSettle();

    // The constrained child, not the full-width Align around it.
    final column = tester.getRect(
      find
          .descendant(
            of: find.byType(MaxWidthContent).last,
            matching: find.byType(ConstrainedBox),
          )
          .first,
    );
    final back = tester.getRect(find.byType(BackButton));
    final more = tester.getRect(find.byTooltip('More'));

    expect(back.left, moreOrLessEquals(column.left, epsilon: 1));
    // Actions end at the column edge, minus PopupMenuButton's own 4px
    // padding (the same gap it has from the screen edge on phones).
    expect(column.right - more.right, moreOrLessEquals(4, epsilon: 1));
  });
}
