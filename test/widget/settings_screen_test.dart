import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/core/app_info.dart';
import 'package:job_application_tracker/data/backup/backup_service.dart';
import 'package:job_application_tracker/data/database/app_database.dart';
import 'package:job_application_tracker/data/seed/demo_data_seeder.dart';
import 'package:job_application_tracker/data/settings/settings_store.dart';
import 'package:job_application_tracker/features/settings/settings_screen.dart';

import '../helpers/fakes.dart';
import '../helpers/pump_app.dart';
import '../helpers/test_database.dart';

const _tallPhone = Size(390, 1400);

Future<void> seedDemo(AppDatabase db) =>
    DemoDataSeeder(db, clock: FakeClock.standard().call).seed();

Future<void> openSettings(WidgetTester tester) async {
  await tester.tapTab('Settings');
}

Brightness currentBrightness(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(SettingsScreen))).brightness;

void main() {
  testWidgets('theme choice applies and survives a restart', (tester) async {
    final settings = InMemorySettingsStore();
    await tester.pumpApp(settings: settings);
    await openSettings(tester);
    expect(currentBrightness(tester), Brightness.light);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(currentBrightness(tester), Brightness.dark);

    // "Restart": a fresh app with the same stored settings.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpApp(settings: settings);
    await openSettings(tester);
    expect(currentBrightness(tester), Brightness.dark);
  });

  testWidgets('exports a JSON backup and a CSV through the share sheet', (
    tester,
  ) async {
    final files = FakeFileExchange();
    await tester.pumpApp(size: _tallPhone, seed: seedDemo, files: files);
    await openSettings(tester);

    await tester.tap(find.text('Export backup'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Export applications as CSV'));
    await tester.pumpAndSettle();

    expect(files.shared.map((f) => f.fileName), [
      'job-tracker-backup-2026-09-26.json',
      'job-tracker-applications-2026-09-26.csv',
    ]);
    final backup = jsonDecode(files.shared.first.content) as Map;
    expect(backup['applications'], hasLength(13));
    expect(files.shared.last.mimeType, 'text/csv');
  });

  testWidgets('export is disabled while there is no data', (tester) async {
    final files = FakeFileExchange();
    await tester.pumpApp(files: files);
    await openSettings(tester);

    await tester.tap(find.text('Export backup'));
    await tester.pumpAndSettle();
    expect(files.shared, isEmpty);
  });

  testWidgets('restores a backup after confirmation', (tester) async {
    // Make a backup from demo data in a separate database.
    final source = createTestDatabase();
    await seedDemo(source);
    final json = await BackupService(
      source,
      clock: FakeClock.standard().call,
    ).exportJson();

    final db = await tester.pumpApp(
      size: _tallPhone,
      files: FakeFileExchange(fileToPick: json),
    );
    await openSettings(tester);

    await tester.tap(find.text('Restore from backup'));
    await tester.pumpAndSettle();
    expect(find.text('Restore this backup?'), findsOneWidget);
    expect(find.textContaining('(13 applications)'), findsOneWidget);

    await tester.tap(find.text('Replace data'));
    await tester.pumpAndSettle();

    expect(find.text('Backup restored'), findsOneWidget);
    expect(await db.select(db.applications).get(), hasLength(13));
  });

  testWidgets('an invalid backup shows an error and changes nothing', (
    tester,
  ) async {
    final db = await tester.pumpApp(
      size: _tallPhone,
      seed: seedDemo,
      files: FakeFileExchange(fileToPick: '{"hello": "world"}'),
    );
    await openSettings(tester);

    await tester.tap(find.text('Restore from backup'));
    await tester.pumpAndSettle();

    expect(find.text('This file is not a Job Tracker backup.'), findsOneWidget);
    expect(find.text('Restore this backup?'), findsNothing);
    expect(await db.select(db.applications).get(), hasLength(13));
  });

  testWidgets('delete all needs two confirmations and typing DELETE', (
    tester,
  ) async {
    final db = await tester.pumpApp(size: _tallPhone, seed: seedDemo);
    await openSettings(tester);

    await tester.tap(find.text('Delete all data'));
    await tester.pumpAndSettle();
    expect(find.textContaining('All 13 applications'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    final deleteButton = find.widgetWithText(FilledButton, 'Delete everything');
    expect(tester.widget<FilledButton>(deleteButton).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'delete');
    await tester.pump();
    expect(
      tester.widget<FilledButton>(deleteButton).onPressed,
      isNull,
      reason: 'The phrase is case-sensitive.',
    );

    await tester.enterText(find.byType(TextField), 'DELETE');
    await tester.pump();
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('All data deleted'), findsOneWidget);
    expect(await db.select(db.applications).get(), isEmpty);
  });

  testWidgets('about shows the app version', (tester) async {
    await tester.pumpApp(size: _tallPhone);
    await openSettings(tester);

    expect(
      find.text('Version ${AppInfo.version} (${AppInfo.buildNumber})'),
      findsOneWidget,
    );
  });
}
