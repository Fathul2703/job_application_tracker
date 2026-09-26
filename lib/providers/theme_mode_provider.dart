import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/data/settings/settings_store.dart';

/// User preferences storage. Overridden in `main` with the real store
/// (opened before the first frame) and in tests with an in-memory one.
final settingsStoreProvider = Provider<SettingsStore>(
  (ref) => InMemorySettingsStore(),
);

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

/// The user's theme preference (system, light or dark), persisted across
/// launches.
class ThemeModeController extends Notifier<ThemeMode> {
  static const _key = SharedPreferencesSettingsStore.themeModeKey;

  @override
  ThemeMode build() {
    final stored = ref.watch(settingsStoreProvider).getString(_key);
    return ThemeMode.values.asNameMap()[stored] ?? ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    // Fire-and-forget: the UI already reflects the change; a failed write
    // only means the default is used next launch.
    unawaited(ref.read(settingsStoreProvider).setString(_key, mode.name));
  }
}
