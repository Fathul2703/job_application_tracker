import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:job_application_tracker/core/app_info.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/features/settings/data_controller.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/providers/theme_mode_provider.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/confirm_dialog.dart';
import 'package:job_application_tracker/shared/widgets/content_app_bar.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';
import 'package:job_application_tracker/shared/widgets/type_to_confirm_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(dataControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        _showMessage(context, errorMessage(error));
      }
    });

    return Scaffold(
      appBar: const ContentAppBar(title: Text('Settings')),
      body: MaxWidthContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: const [
            SectionHeader('Appearance'),
            _ThemeCard(),
            SectionHeader('Your data'),
            _DataCard(),
            SectionHeader('About'),
            _AboutCard(),
          ],
        ),
      ),
    );
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Where the share sheet should point on iPad: the tapped tile.
Rect? _originOf(BuildContext context) {
  final box = context.findRenderObject();
  return box is RenderBox && box.hasSize
      ? box.localToGlobal(Offset.zero) & box.size
      : null;
}

class _ThemeCard extends ConsumerWidget {
  const _ThemeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return Card(
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
    );
  }
}

class _DataCard extends ConsumerWidget {
  const _DataCard();

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(dataControllerProvider.notifier);
    final current = ref.read(applicationsProvider).value?.length ?? 0;
    final snapshot = await controller.pickBackup();
    if (snapshot == null || !context.mounted) return;

    final count = snapshot.applications.length;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Restore this backup?',
      message:
          'All current data ($current '
          '${current == 1 ? 'application' : 'applications'}) will be '
          'replaced by the backup from '
          '${DateFormat.yMMMd().format(snapshot.exportedAt.toLocal())} '
          '($count ${count == 1 ? 'application' : 'applications'}). '
          'This cannot be undone.',
      confirmLabel: 'Replace data',
      destructive: true,
    );
    if (!confirmed) return;
    if (await controller.restore(snapshot) && context.mounted) {
      _showMessage(context, 'Backup restored');
    }
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(dataControllerProvider.notifier);
    final count = ref.read(applicationsProvider).value?.length ?? 0;
    final proceed = await showConfirmDialog(
      context,
      title: 'Delete all data?',
      message:
          'All $count ${count == 1 ? 'application' : 'applications'}, with '
          'their interviews, checklists and notes, will be removed from this '
          'device. Export a backup first if you might need them.',
      confirmLabel: 'Continue',
      destructive: true,
    );
    if (!proceed || !context.mounted) return;

    final confirmed = await showTypeToConfirmDialog(
      context,
      title: 'This cannot be undone',
      message: 'To permanently delete all data, type DELETE below.',
      confirmLabel: 'Delete everything',
    );
    if (confirmed && await controller.deleteAll() && context.mounted) {
      _showMessage(context, 'All data deleted');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(dataControllerProvider).isLoading;
    final hasData = ref.watch(applicationsProvider).value?.isNotEmpty ?? false;
    final controller = ref.read(dataControllerProvider.notifier);
    final deleteEnabled = !busy && hasData;
    // Destructive red only while actionable; disabled tiles use the default
    // muted color like the others.
    final deleteColor = deleteEnabled ? context.colorScheme.error : null;

    return Card(
      child: Column(
        children: [
          // Keeps the card height stable while busy.
          SizedBox(
            height: 2,
            child: busy ? const LinearProgressIndicator() : null,
          ),
          Builder(
            builder: (tileContext) => ListTile(
              enabled: !busy && hasData,
              leading: const Icon(Icons.ios_share),
              title: const Text('Export backup'),
              subtitle: const Text(
                'All data as a JSON file you can restore later',
              ),
              onTap: () =>
                  controller.exportBackup(origin: _originOf(tileContext)),
            ),
          ),
          Builder(
            builder: (tileContext) => ListTile(
              enabled: !busy && hasData,
              leading: const Icon(Icons.table_view_outlined),
              title: const Text('Export applications as CSV'),
              subtitle: const Text('Open in Excel, Numbers or Google Sheets'),
              onTap: () => controller.exportCsv(origin: _originOf(tileContext)),
            ),
          ),
          ListTile(
            enabled: !busy,
            leading: const Icon(Icons.settings_backup_restore),
            title: const Text('Restore from backup'),
            subtitle: const Text('Replaces all current data'),
            onTap: () => _restore(context, ref),
          ),
          const Divider(indent: AppSpacing.md, endIndent: AppSpacing.md),
          ListTile(
            enabled: deleteEnabled,
            leading: Icon(Icons.delete_forever_outlined, color: deleteColor),
            title: Text(
              'Delete all data',
              style: TextStyle(color: deleteColor),
            ),
            subtitle: const Text('Permanently remove every application'),
            onTap: () => _deleteAll(context, ref),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(AppInfo.name),
            subtitle: Text(
              'Version ${AppInfo.version} (${AppInfo.buildNumber})',
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Private by design'),
            subtitle: Text(
              'Your data stays on this device. No account, no cloud, no '
              'tracking. Use backups to move it to another device.',
            ),
          ),
        ],
      ),
    );
  }
}
