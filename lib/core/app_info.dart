/// App identity shown in Settings → About.
///
/// Keep [version] and [buildNumber] in sync with `version:` in pubspec.yaml;
/// `test/unit/app_info_test.dart` fails when they drift apart.
abstract final class AppInfo {
  static const name = 'Job Tracker';
  static const version = '1.0.0';
  static const buildNumber = 1;
}
