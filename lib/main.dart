import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/app.dart';

void main() {
  runApp(const ProviderScope(child: JobTrackerApp()));
}
