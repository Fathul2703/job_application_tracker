import 'package:intl/intl.dart';
import 'package:job_application_tracker/core/utils/date_only.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';

/// Display formatting for dates and money. The UI is English, so numbers use
/// `en` grouping (12,000,000) regardless of currency.
abstract final class Formatters {
  static final DateFormat _date = DateFormat.yMMMd();
  static final DateFormat _monthDay = DateFormat.MMMd();
  static final DateFormat _time = DateFormat.jm();

  /// A date-only value (UTC midnight), e.g. "Sep 26, 2026".
  /// Reads calendar fields directly, so no time-zone shift can occur.
  static String date(DateTime dateOnly) =>
      _date.format(DateTime(dateOnly.year, dateOnly.month, dateOnly.day));

  /// "Sep 26" in the current year, otherwise "Sep 26, 2025".
  static String shortDate(DateTime dateOnly, {required DateTime now}) {
    final local = DateTime(dateOnly.year, dateOnly.month, dateOnly.day);
    return local.year == now.year
        ? _monthDay.format(local)
        : _date.format(local);
  }

  /// A UTC timestamp in the device's time zone, e.g. "Sep 26, 2026 · 10:30 AM".
  static String timestamp(DateTime utc) {
    final local = utc.toLocal();
    return '${_date.format(local)} · ${_time.format(local)}';
  }

  /// Whole calendar days from today to [dateOnly]; negative for the past.
  static int daysFromToday(DateTime dateOnly, {required DateTime now}) =>
      dateOnly.toDateOnly().difference(now.toDateOnly()).inDays;

  /// "today", "tomorrow", "in 3 days", "yesterday", "5 days ago".
  static String relativeDay(DateTime dateOnly, {required DateTime now}) {
    final days = daysFromToday(dateOnly, now: now);
    return switch (days) {
      0 => 'today',
      1 => 'tomorrow',
      -1 => 'yesterday',
      > 1 => 'in $days days',
      _ => '${-days} days ago',
    };
  }

  /// Salary range, or `null` when neither bound is set.
  ///
  /// Full: "Rp 12,000,000 – 16,000,000 per month".
  /// Compact: "Rp 12M – 16M /mo".
  static String? salary({
    required int? min,
    required int? max,
    required String currency,
    SalaryPeriod? period,
    bool compact = false,
  }) {
    if (min == null && max == null) return null;

    final symbol = currencySymbol(currency);
    final number = compact
        ? NumberFormat.compact(locale: 'en')
        : NumberFormat.decimalPattern('en');
    final prefix = symbol.length > 1 ? '$symbol ' : symbol;

    final range = switch ((min, max)) {
      (final int a, final int b) when a == b => '$prefix${number.format(a)}',
      (final int a, final int b) =>
        '$prefix${number.format(a)} – ${number.format(b)}',
      (final int a, null) => 'From $prefix${number.format(a)}',
      (null, final int b) => 'Up to $prefix${number.format(b)}',
      (null, null) => '',
    };

    final suffix = switch (period) {
      null => '',
      SalaryPeriod.monthly => compact ? ' /mo' : ' per month',
      SalaryPeriod.yearly => compact ? ' /yr' : ' per year',
    };
    return '$range$suffix';
  }

  /// "Rp" for IDR, "$" for USD; falls back to the code itself.
  static String currencySymbol(String currency) {
    try {
      return NumberFormat.simpleCurrency(name: currency).currencySymbol;
    } on ArgumentError {
      return currency;
    }
  }

  /// Digits with thousands separators, for salary inputs: 12000000 → "12,000,000".
  static String groupedDigits(int value) =>
      NumberFormat.decimalPattern('en').format(value);
}
