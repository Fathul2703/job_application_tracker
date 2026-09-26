import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/widgets/application_display.dart';

Application _app({String? location, WorkMode? workMode}) => Application(
  id: 1,
  companyName: 'Acme',
  positionTitle: 'Dev',
  status: ApplicationStatus.saved,
  salaryCurrency: 'IDR',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  location: location,
  workMode: workMode,
);

void main() {
  test('locationSummary joins location and work mode', () {
    expect(
      _app(location: 'Jakarta', workMode: WorkMode.hybrid).locationSummary,
      'Jakarta · Hybrid',
    );
    expect(_app(workMode: WorkMode.onsite).locationSummary, 'On-site');
    expect(_app().locationSummary, isEmpty);
  });

  test('locationSummary does not repeat "Remote"', () {
    expect(
      _app(location: 'remote', workMode: WorkMode.remote).locationSummary,
      'remote',
    );
  });
}
