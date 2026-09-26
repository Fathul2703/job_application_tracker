import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/core/theme/app_theme.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/shared/widgets/status_breakdown.dart';

void main() {
  testWidgets('one labelled row per non-empty status, bars sized by count', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: SizedBox(
            width: 360,
            child: StatusBreakdown(
              counts: {
                ApplicationStatus.saved: 0,
                ApplicationStatus.applied: 4,
                ApplicationStatus.rejected: 1,
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Applied'), findsOneWidget);
    expect(find.text('Rejected'), findsOneWidget);
    expect(find.text('Saved'), findsNothing);
    expect(find.bySemanticsLabel('Applied: 4 applications'), findsOneWidget);
    expect(find.bySemanticsLabel('Rejected: 1 application'), findsOneWidget);

    final bars = find.descendant(
      of: find.byType(StatusBreakdown),
      matching: find.byWidgetPredicate(
        (w) => w is Container && w.decoration is BoxDecoration,
      ),
    );
    expect(bars, findsNWidgets(2));
    final applied = tester.getSize(bars.at(0));
    final rejected = tester.getSize(bars.at(1));
    // Rendered, not collapsed, and proportional (4 : 1).
    expect(applied.height, 8);
    expect(applied.width / rejected.width, closeTo(4, 0.01));
    semantics.dispose();
  });
}
