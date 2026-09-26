import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/seed/demo_data_seeder.dart';
import 'package:job_application_tracker/features/applications/widgets/application_card.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

Future<void> seedDemo(AppDatabase db) =>
    DemoDataSeeder(db, clock: FakeClock.standard().call).seed();

/// Every main screen, reached from a freshly pumped app.
final Map<String, Future<void> Function(WidgetTester)> screens = {
  'Dashboard': (tester) async {},
  'Applications': (tester) => tester.tapTab('Applications'),
  'Application detail': (tester) async {
    await tester.tapTab('Applications');
    await tester.tap(find.byType(ApplicationCard).first);
    await tester.pumpAndSettle();
  },
  'Interviews tab': (tester) async {
    await tester.tapTab('Applications');
    await tester.tap(find.byType(ApplicationCard).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Interviews'));
    await tester.pumpAndSettle();
  },
  'Checklist tab': (tester) async {
    await tester.tapTab('Applications');
    await tester.tap(find.byType(ApplicationCard).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checklist'));
    await tester.pumpAndSettle();
  },
  'New application form': (tester) async {
    await tester.tapTab('Applications');
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
  },
  'Analytics': (tester) => tester.tapTab('Analytics'),
  'Settings': (tester) => tester.tapTab('Settings'),
};

void main() {
  group('meets accessibility guidelines', () {
    for (final MapEntry(key: name, value: open) in screens.entries) {
      for (final brightness in Brightness.values) {
        testWidgets('$name (${brightness.name})', (tester) async {
          final semantics = tester.ensureSemantics();
          tester.platformDispatcher.platformBrightnessTestValue = brightness;
          addTearDown(
            tester.platformDispatcher.clearPlatformBrightnessTestValue,
          );

          await tester.pumpApp(seed: seedDemo);
          await open(tester);

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          semantics.dispose();
        });
      }
    }
  });

  group('lays out at 200% text size without overflow', () {
    for (final MapEntry(key: name, value: open) in screens.entries) {
      testWidgets(name, (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpApp(seed: seedDemo);
        await open(tester);

        // Layout overflows are reported as exceptions during the pump.
        expect(tester.takeException(), isNull);
      });
    }
  });
}
