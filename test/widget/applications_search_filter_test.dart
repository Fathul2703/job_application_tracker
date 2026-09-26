import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/domain/models/application_query.dart';
import 'package:job_application_tracker/features/applications/widgets/application_card.dart';
import 'package:job_application_tracker/features/applications/widgets/applications_search_field.dart';

import '../helpers/pump_app.dart';
import '../helpers/query_fixtures.dart';

/// Tall enough that all four fixture cards are built.
const _tallPhone = Size(390, 1400);

List<String> visibleCompanies(WidgetTester tester) => tester
    .widgetList<ApplicationCard>(find.byType(ApplicationCard))
    .map((card) => card.application.companyName)
    .toList();

Future<void> openApplications(WidgetTester tester) async {
  await tester.pumpApp(size: _tallPhone, seed: seedQueryFixtures);
  await tester.tapTab('Applications');
}

Future<void> search(WidgetTester tester, String text) async {
  await tester.enterText(
    find.descendant(
      of: find.byType(ApplicationsSearchField),
      matching: find.byType(EditableText),
    ),
    text,
  );
  await tester.pump(ApplicationsSearchField.debounce);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('search narrows the list after the debounce', (tester) async {
    await openApplications(tester);
    expect(visibleCompanies(tester), hasLength(4));
    expect(find.text('4 applications · 3 active'), findsOneWidget);

    await search(tester, 'bandung');

    expect(visibleCompanies(tester), ['Sagara Labs']);
    expect(find.text('Showing 1 of 4'), findsOneWidget);
  });

  testWidgets('no matches offers to clear search and filters', (tester) async {
    await openApplications(tester);
    await search(tester, 'zzz');

    expect(find.text('No matching applications'), findsOneWidget);
    await tester.tap(find.text('Clear search and filters'));
    await tester.pumpAndSettle();

    expect(visibleCompanies(tester), hasLength(4));
    final field = tester.widget<EditableText>(
      find.descendant(
        of: find.byType(ApplicationsSearchField),
        matching: find.byType(EditableText),
      ),
    );
    expect(field.controller.text, isEmpty);
  });

  testWidgets('status chips show counts and toggle a filter', (tester) async {
    await openApplications(tester);

    // The chip row scrolls horizontally; Interview is past the screen edge.
    final interviewChip = find.widgetWithText(FilterChip, 'Interview 1');
    await tester.ensureVisible(interviewChip);
    await tester.pumpAndSettle();
    await tester.tap(interviewChip);
    await tester.pumpAndSettle();
    expect(visibleCompanies(tester), ['Arunika Digital']);

    await tester.tap(find.widgetWithText(FilterChip, 'Interview 1'));
    await tester.pumpAndSettle();
    expect(visibleCompanies(tester), hasLength(4));
  });

  testWidgets('filter sheet applies live and shows the result count', (
    tester,
  ) async {
    await openApplications(tester);

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Remote'));
    await tester.pumpAndSettle();
    expect(find.text('Show 2 results'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Internship'));
    await tester.pumpAndSettle();
    expect(find.text('Show 1 result'), findsOneWidget);

    await tester.tap(find.text('Show 1 result'));
    await tester.pumpAndSettle();

    expect(visibleCompanies(tester), ['100% Remote Co']);
    expect(find.byTooltip('Filters (2 active)'), findsOneWidget);
  });

  testWidgets('sort menu reorders the list', (tester) async {
    await openApplications(tester);

    await tester.tap(find.byTooltip('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<ApplicationSort>, 'Company A–Z'),
    );
    await tester.pumpAndSettle();

    expect(visibleCompanies(tester), [
      '100% Remote Co',
      'Arunika Digital',
      'kopi kode',
      'Sagara Labs',
    ]);
    expect(
      find.text('4 applications · 3 active · by company a–z'),
      findsOneWidget,
    );
  });

  testWidgets('filters survive switching tabs', (tester) async {
    await openApplications(tester);
    await tester.tap(find.widgetWithText(FilterChip, 'Saved 1'));
    await tester.pumpAndSettle();

    await tester.tapTab('Dashboard');
    await tester.tapTab('Applications');

    expect(visibleCompanies(tester), ['kopi kode']);
  });
}
