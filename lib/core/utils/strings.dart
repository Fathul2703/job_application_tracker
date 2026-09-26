extension OptionalText on String? {
  /// Trimmed value, or `null` when the string is null or blank.
  String? get trimmedOrNull {
    final trimmed = this?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
