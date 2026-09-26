import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/app.dart';
import 'package:job_application_tracker/data/settings/settings_store.dart';
import 'package:job_application_tracker/providers/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Loaded before the first frame so the saved theme applies immediately.
  final settings = await SharedPreferencesSettingsStore.open();

  runApp(
    ProviderScope(
      overrides: [settingsStoreProvider.overrideWithValue(settings)],
      child: const JobTrackerApp(),
    ),
  );
}
