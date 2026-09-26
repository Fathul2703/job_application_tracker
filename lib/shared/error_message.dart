import 'package:job_application_tracker/domain/errors.dart';

/// A short, user-facing message for an error thrown by a repository.
String errorMessage(Object error) => switch (error) {
  ValidationException(:final problems) => problems.join('\n'),
  NotFoundException() => 'This item no longer exists.',
  _ => 'Something went wrong. Please try again.',
};
