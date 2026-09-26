import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/widgets/application_display.dart';
import 'package:job_application_tracker/features/applications/widgets/status_timeline.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';
import 'package:job_application_tracker/shared/open_link.dart';
import 'package:job_application_tracker/shared/widgets/info_row.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Status, details, dates and status history of an application.
class OverviewTab extends ConsumerWidget {
  const OverviewTab({
    required this.app,
    required this.busy,
    required this.onChangeStatus,
    super.key,
  });

  final Application app;
  final bool busy;
  final VoidCallback onChangeStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(statusHistoryProvider(app.id)).value ?? const [];
    final now = ref.watch(clockProvider)();

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      children: [
        _StatusCard(app: app, busy: busy, onChange: onChangeStatus),
        const SectionHeader('Details'),
        _DetailsCard(app: app),
        const SectionHeader('Dates'),
        _DatesCard(app: app, now: now),
        if (history.isNotEmpty) ...[
          const SectionHeader('Timeline'),
          Card(child: StatusTimeline(history: history)),
        ],
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Open link',
                icon: const Icon(Icons.open_in_new),
                onPressed: () => openLink(context, jobUrl),
              ),
              IconButton(
                tooltip: 'Copy link',
                icon: const Icon(Icons.copy_outlined),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: jobUrl));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Link copied')),
                    );
                },
              ),
            ],
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
