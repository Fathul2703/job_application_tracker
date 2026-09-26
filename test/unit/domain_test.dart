import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/core/utils/date_only.dart';
import 'package:job_application_tracker/core/utils/strings.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';

void main() {
  group('ApplicationStatus', () {
    test('rejected and withdrawn are terminal', () {
      final terminal = ApplicationStatus.values.where((s) => s.isTerminal);
      expect(terminal, [
        ApplicationStatus.rejected,
        ApplicationStatus.withdrawn,
      ]);
    });

    test('hasReached follows the pipeline order', () {
      expect(
        ApplicationStatus.offer.hasReached(ApplicationStatus.interview),
        isTrue,
      );
      expect(
        ApplicationStatus.screening.hasReached(ApplicationStatus.interview),
        isFalse,
      );
      expect(
        ApplicationStatus.interview.hasReached(ApplicationStatus.interview),
        isTrue,
      );
    });

    test('terminal statuses never "reach" a pipeline stage', () {
      expect(
        ApplicationStatus.rejected.hasReached(ApplicationStatus.applied),
        isFalse,
      );
      expect(
        ApplicationStatus.offer.hasReached(ApplicationStatus.rejected),
        isFalse,
      );
    });
  });

  group('ApplicationDraft.validate', () {
    test('accepts a minimal draft', () {
      expect(
        const ApplicationDraft(
          companyName: 'Acme',
          positionTitle: 'Dev',
        ).validate(),
        isEmpty,
      );
    });

    test('reports each problem', () {
      final problems = ApplicationDraft(
        companyName: ' ',
        positionTitle: 'x' * 201,
        salaryMin: -1,
        salaryCurrency: 'rupiah',
      ).validate();

      expect(problems, hasLength(4));
    });

    test('rejects min salary above max salary', () {
      expect(
        const ApplicationDraft(
          companyName: 'Acme',
          positionTitle: 'Dev',
          salaryMin: 10,
          salaryMax: 5,
        ).validate(),
        ['Minimum salary cannot exceed maximum salary.'],
      );
    });
  });

  group('DateOnly', () {
    test('keeps the local calendar date as UTC midnight', () {
      expect(
        DateTime(2026, 10, 5, 23, 59).toDateOnly(),
        DateTime.utc(2026, 10, 5),
      );
    });

    test('is idempotent', () {
      final date = DateTime.utc(2026, 10, 5);
      expect(date.toDateOnly(), date);
    });
  });

  test('trimmedOrNull', () {
    expect(null.trimmedOrNull, isNull);
    expect('   '.trimmedOrNull, isNull);
    expect(' a '.trimmedOrNull, 'a');
  });
}
