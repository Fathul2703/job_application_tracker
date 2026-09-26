import 'package:job_application_tracker/domain/models/application.dart';

extension ApplicationDisplay on Application {
  /// "Jakarta · Hybrid". Omits the work mode when the location already says
  /// it (e.g. location "Remote" with work mode Remote).
  String get locationSummary {
    final place = location;
    final mode = workMode?.label;
    if (place != null &&
        mode != null &&
        place.toLowerCase() == mode.toLowerCase()) {
      return place;
    }
    return [?place, ?mode].join(' · ');
  }
}
