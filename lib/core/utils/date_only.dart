/// Helpers for calendar dates without a time of day (deadline, applied date).
///
/// Date-only values are stored as **UTC midnight of the calendar date** the
/// user picked, e.g. 5 Oct → `2026-10-05T00:00:00Z`. Read them with
/// `.year/.month/.day` and never call `toLocal()` on them, or the date can
/// shift by a day depending on the device time zone.
extension DateOnly on DateTime {
  /// The calendar date of this value *as the user sees it* (local date for
  /// local values), as UTC midnight.
  DateTime toDateOnly() => DateTime.utc(year, month, day);
}
