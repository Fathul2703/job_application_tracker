import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/shared/widgets/company_avatar.dart';
import 'package:job_application_tracker/shared/widgets/form_fields.dart';

void main() {
  final now = DateTime(2026, 9, 26, 10, 30);

  group('dates', () {
    test('date and shortDate', () {
      expect(Formatters.date(DateTime.utc(2026, 10, 5)), 'Oct 5, 2026');
      expect(
        Formatters.shortDate(DateTime.utc(2026, 10, 5), now: now),
        'Oct 5',
      );
      expect(
        Formatters.shortDate(DateTime.utc(2025, 12, 31), now: now),
        'Dec 31, 2025',
      );
    });

    test('relativeDay', () {
      String rel(int y, int m, int d) =>
          Formatters.relativeDay(DateTime.utc(y, m, d), now: now);

      expect(rel(2026, 9, 26), 'today');
      expect(rel(2026, 9, 27), 'tomorrow');
      expect(rel(2026, 9, 25), 'yesterday');
      expect(rel(2026, 10, 1), 'in 5 days');
      expect(rel(2026, 9, 16), '10 days ago');
    });
  });

  group('salary', () {
    test('full and compact ranges', () {
      expect(
        Formatters.salary(
          min: 12000000,
          max: 16000000,
          currency: 'IDR',
          period: SalaryPeriod.monthly,
        ),
        'Rp 12,000,000 – 16,000,000 per month',
      );
      expect(
        Formatters.salary(
          min: 12000000,
          max: 16500000,
          currency: 'IDR',
          period: SalaryPeriod.monthly,
          compact: true,
        ),
        'Rp 12M – 16.5M /mo',
      );
    });

    test('open-ended, equal and missing bounds', () {
      expect(
        Formatters.salary(min: 90000, max: null, currency: 'USD'),
        r'From $90,000',
      );
      expect(
        Formatters.salary(min: null, max: 5000000, currency: 'IDR'),
        'Up to Rp 5,000,000',
      );
      expect(Formatters.salary(min: 100, max: 100, currency: 'IDR'), 'Rp 100');
      expect(Formatters.salary(min: null, max: null, currency: 'IDR'), isNull);
    });

    test('unknown currency codes fall back to the code', () {
      expect(Formatters.currencySymbol('XYZ'), isNotEmpty);
    });
  });

  group('ThousandsSeparatorInputFormatter', () {
    const formatter = ThousandsSeparatorInputFormatter();

    TextEditingValue format(String text) => formatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: text),
    );

    test('groups digits and parses them back', () {
      expect(format('12000000').text, '12,000,000');
      expect(ThousandsSeparatorInputFormatter.parse('12,000,000'), 12000000);
    });

    test('empty input stays empty', () {
      expect(format('').text, isEmpty);
      expect(ThousandsSeparatorInputFormatter.parse(''), isNull);
    });
  });

  test('company initials', () {
    expect(CompanyAvatar.initialsOf('Arunika Digital'), 'AD');
    expect(CompanyAvatar.initialsOf('kopi'), 'KO');
    expect(CompanyAvatar.initialsOf('X'), 'X');
    expect(CompanyAvatar.initialsOf('  '), '?');
  });
}
