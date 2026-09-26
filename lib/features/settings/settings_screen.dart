import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/providers/theme_mode_provider.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: MaxWidthContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            const SectionHeader('Appearance'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Theme', style: context.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto_outlined),
                          label: Text('System'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined),
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined),
                          label: Text('Dark'),
                        ),
                      ],
                      selected: {themeMode},
                      onSelectionChanged: (selection) => ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(selection.first),
                    ),
                  ],
                ),
              ),
            ),
            const SectionHeader('About'),
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Job Tracker'),
                subtitle: Text(
                  'A personal, local-first job application tracker. '
                  'Your data stays on this device.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
