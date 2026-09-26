import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  const tabs = ['Dashboard', 'Applications', 'Analytics', 'Settings'];

  group('AppShell on phones', () {
    testWidgets('starts on Dashboard with a bottom NavigationBar', (
      tester,
    ) async {
      await tester.pumpApp();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.widgetWithText(AppBar, 'Dashboard'), findsOneWidget);
    });

    testWidgets('switches between all four tabs', (tester) async {
      await tester.pumpApp();

      for (final tab in tabs) {
        await tester.tap(
          find.descendant(
            of: find.byType(NavigationBar),
            matching: find.text(tab),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.widgetWithText(AppBar, tab), findsOneWidget);
        final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
        expect(bar.selectedIndex, tabs.indexOf(tab));
      }
    });
  });

  group('AppShell on wider windows', () {
    testWidgets('uses a compact NavigationRail on tablet portrait', (
      tester,
    ) async {
      await tester.pumpApp(size: TestSizes.tabletPortrait);

      expect(find.byType(NavigationBar), findsNothing);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
    });

    testWidgets('extends the NavigationRail on tablet landscape', (
      tester,
    ) async {
      await tester.pumpApp(size: TestSizes.tabletLandscape);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);

      await tester.tap(
        find.descendant(
          of: find.byType(NavigationRail),
          matching: find.text('Analytics'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Analytics'), findsOneWidget);
    });
  });
}
