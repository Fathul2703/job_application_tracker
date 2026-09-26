import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/core/theme/app_theme.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/features/dashboard/widgets/pipeline_bar.dart';

void main() {
  testWidgets(
    'draws one visible segment per non-empty status, sized by count',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SizedBox(
              width: 300,
              child: PipelineBar(
                counts: {
                  ApplicationStatus.saved: 0,
                  ApplicationStatus.applied: 3,
                  ApplicationStatus.offer: 1,
                },
              ),
            ),
          ),
        ),
      );

      final segments = find.descendant(
        of: find.byType(PipelineBar),
        matching: find.byType(ColoredBox),
      );
      expect(segments, findsNWidgets(2));

      final applied = tester.getSize(segments.at(0));
      final offer = tester.getSize(segments.at(1));
      // Regression: segments once collapsed to zero height.
      expect(applied.height, 12);
      expect(offer.height, 12);
      expect(applied.width, greaterThan(offer.width * 2));

      expect(find.text('Applied 3'), findsOneWidget);
      expect(find.text('Saved 0'), findsNothing);
      expect(
        find.bySemanticsLabel('Pipeline: 3 applied, 1 offer'),
        findsOneWidget,
      );
    },
  );
}
