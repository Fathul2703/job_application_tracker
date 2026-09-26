/// Thrown when user input breaks a domain rule. [problems] are
/// human-readable and safe to show in the UI.
class ValidationException implements Exception {
  const ValidationException(this.problems);

  final List<String> problems;

  @override
  String toString() => 'ValidationException: ${problems.join(' ')}';
}

/// Thrown when a record that must exist is missing (e.g. deleted meanwhile).
class NotFoundException implements Exception {
  const NotFoundException(this.entity, this.id);

  final String entity;
  final int id;

  @override
  String toString() => 'NotFoundException: $entity #$id not found';
}
