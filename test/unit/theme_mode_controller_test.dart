import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/providers/theme_mode_provider.dart';

void main() {
  test('defaults to the system theme', () {
    final container = ProviderContainer.test();

    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('setThemeMode updates the state', () {
    final container = ProviderContainer.test();

    container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
