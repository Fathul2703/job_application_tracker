import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/application_controllers.dart';
import 'package:job_application_tracker/features/applications/widgets/application_display.dart';
import 'package:job_application_tracker/features/applications/widgets/status_picker_sheet.dart';
import 'package:job_application_tracker/features/applications/widgets/status_timeline.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/company_avatar.dart';
import 'package:job_application_tracker/shared/widgets/confirm_dialog.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/info_row.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

class ApplicationDetailScreen extends ConsumerStatefulWidget {
  const ApplicationDetailScreen({required this.applicationId, super.key});

  final int applicationId;

  @override
  ConsumerState<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState
    extends ConsumerState<ApplicationDetailScreen> {
  /// Set while deleting, so the brief "not found" state is not shown before
  /// navigating away.
  bool _deleting = false;

  ApplicationDetailController get _controller => ref.read(
    applicationDetailControllerProvider(widget.applicationId).notifier,
  );

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _changeStatus(Application app) async {
    final picked = await showStatusPicker(context, current: app.status);
    if (picked == null || picked == app.status) return;
    if (await _controller.changeStatus(picked)) {
      unawaited(HapticFeedback.selectionClick());
      if (mounted) _showMessage('Moved to ${picked.label}');
    }
  }

  Future<void> _delete(Application app) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete application?',
      message:
          '${app.positionTitle} at ${app.companyName} will be deleted with '
          'its interviews, checklist and notes. This cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    setState(() => _deleting = true);
    final deleted = await _controller.delete();
    if (!mounted) return;
    if (deleted) {
      _showMessage('Application deleted');
      context.go(AppRoutes.applications);
    } else {
      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.applicationId;
    ref.listen(applicationDetailControllerProvider(id), (_, next) {
      if (next case AsyncError(:final error)) _showMessage(errorMessage(error));
    });

    return switch (ref.watch(applicationProvider(id))) {
      AsyncData(value: final app?) => _buildDetail(app),
      AsyncData() when _deleting => const Scaffold(),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.search_off,
          title: 'Application not found',
          message: 'It may have been deleted.',
          action: FilledButton(
            onPressed: () => context.go(AppRoutes.applications),
            child: const Text('Back to applications'),
          ),
        ),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load application',
          message: errorMessage(error),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }

  Widget _buildDetail(Application app) {
    final busy = ref
        .watch(applicationDetailControllerProvider(app.id))
        .isLoading;
    final history = ref.watch(statusHistoryProvider(app.id)).value ?? const [];
    final now = ref.watch(clockProvider)();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.editApplication(app.id)),
          ),
          PopupMenuButton<void>(
            tooltip: 'More',
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => _delete(app),
                child: const ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Delete'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: MaxWidthContent(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.xxl,
          ),
          children: [
            _Header(app: app),
            const SizedBox(height: AppSpacing.lg),
            _StatusCard(
              app: app,
              busy: busy,
              onChange: () => _changeStatus(app),
            ),
            const SectionHeader('Details'),
            _DetailsCard(app: app),
            const SectionHeader('Dates'),
            _DatesCard(app: app, now: now),
            if (history.isNotEmpty) ...[
              const SectionHeader('Timeline'),
              Card(child: StatusTimeline(history: history)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.app});

  final Application app;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CompanyAvatar(app.companyName, size: 56),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(app.positionTitle, style: context.textTheme.headlineSmall),
              const SizedBox(height: 2),
              Text(
                app.companyName,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.app,
    required this.busy,
    required this.onChange,
  });

  final Application app;
  final bool busy;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final tone = app.status.toneOf(context.statusColors);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: tone.background,
                borderRadius: AppRadius.mdAll,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(app.status.icon, color: tone.foreground),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.status.label, style: context.textTheme.titleMedium),
                  Text(
                    app.status.description,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: busy ? null : onChange,
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.app});

  final Application app;

  @override
  Widget build(BuildContext context) {
    final location = app.locationSummary;
    final salary = Formatters.salary(
      min: app.salaryMin,
      max: app.salaryMax,
      currency: app.salaryCurrency,
      period: app.salaryPeriod,
    );
    final jobUrl = app.jobUrl;

    final rows = [
      if (location.isNotEmpty)
        InfoRow(icon: Icons.place_outlined, label: 'Location', value: location),
      if (app.employmentType case final type?)
        InfoRow(
          icon: Icons.work_outline,
          label: 'Employment type',
          value: type.label,
        ),
      if (salary != null)
        InfoRow(icon: Icons.payments_outlined, label: 'Salary', value: salary),
      if (jobUrl != null)
        InfoRow(
          icon: Icons.link,
          label: 'Job posting',
          value: jobUrl,
          trailing: IconButton(
            tooltip: 'Copy link',
            icon: const Icon(Icons.copy_outlined),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: jobUrl));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('Link copied')));
            },
          ),
        ),
    ];

    return Card(
      child: rows.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'No details yet. Edit to add location, salary or a link.',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Column(children: rows),
            ),
    );
  }
}

class _DatesCard extends StatelessWidget {
  const _DatesCard({required this.app, required this.now});

  final Application app;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    String withRelative(DateTime date) =>
        '${Formatters.date(date)} (${Formatters.relativeDay(date, now: now)})';

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
        child: Column(
          children: [
            if (app.appliedAt case final applied?)
              InfoRow(
                icon: Icons.send_outlined,
                label: 'Applied',
                value: withRelative(applied),
              ),
            if (app.deadlineAt case final deadline?)
              InfoRow(
                icon: Icons.event_outlined,
                label: 'Deadline',
                value: withRelative(deadline),
              ),
            InfoRow(
              icon: Icons.add_circle_outline,
              label: 'Added',
              value: Formatters.timestamp(app.createdAt),
            ),
            InfoRow(
              icon: Icons.update,
              label: 'Last updated',
              value: Formatters.timestamp(app.updatedAt),
            ),
          ],
        ),
      ),
    );
  }
}
