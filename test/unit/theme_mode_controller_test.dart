import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/settings/settings_store.dart';
import 'package:job_application_tracker/providers/theme_mode_provider.dart';

void main() {
  ProviderContainer containerWith(SettingsStore store) =>
      ProviderContainer.test(
        overrides: [settingsStoreProvider.overrideWithValue(store)],
      );

  test('defaults to the system theme', () {
    final container = containerWith(InMemorySettingsStore());
    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('setThemeMode updates the state and persists it', () {
    final store = InMemorySettingsStore();
    containerWith(store)
        .read(themeModeProvider.notifier)
        .setThemeMode(ThemeMode.dark);

    expect(store.values[SharedPreferencesSettingsStore.themeModeKey], 'dark');
    // A new container (next launch) reads the saved value.
    expect(containerWith(store).read(themeModeProvider), ThemeMode.dark);
  });

  test('ignores an unknown stored value', () {
    final store = InMemorySettingsStore({
      SharedPreferencesSettingsStore.themeModeKey: 'sepia',
    });
    expect(containerWith(store).read(themeModeProvider), ThemeMode.system);
  });
}
