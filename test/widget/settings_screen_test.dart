import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/features/settings/settings_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  Future<void> openSettings(WidgetTester tester) async {
    await tester.pumpApp();
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Settings'),
      ),
    );
    await tester.pumpAndSettle();
  }

  Brightness currentBrightness(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(SettingsScreen))).brightness;

  testWidgets('theme selector switches between light and dark', (tester) async {
    await openSettings(tester);
    // Test environment reports a light platform brightness.
    expect(currentBrightness(tester), Brightness.light);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(currentBrightness(tester), Brightness.dark);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(currentBrightness(tester), Brightness.light);
  });
}
