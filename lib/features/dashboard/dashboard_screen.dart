import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/dashboard_items.dart';
import 'package:job_application_tracker/domain/services/dashboard_summary.dart';
import 'package:job_application_tracker/features/applications/widgets/no_applications_state.dart';
import 'package:job_application_tracker/features/dashboard/dashboard_providers.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/date_block.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';
import 'package:job_application_tracker/shared/widgets/stat_tile.dart';
import 'package:job_application_tracker/shared/widgets/status_breakdown.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// What needs attention now: key numbers, upcoming interviews and deadlines,
/// the pipeline and recent activity.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsProvider);
    final hasApplications = applications.value?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      floatingActionButton: hasApplications
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.newApplication),
              icon: const Icon(Icons.add),
              label: const Text('New application'),
            )
          : null,
      body: switch (applications) {
        AsyncValue(value: final list?) when list.isEmpty =>
          const NoApplicationsState(),
        AsyncValue(value: final _?) => const _DashboardBody(),
        AsyncError(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load your dashboard',
          message: errorMessage(error),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider).value;
    if (summary == null) return const SizedBox.shrink();
    final interviews = ref.watch(upcomingInterviewsProvider).value ?? const [];
    final activity = ref.watch(recentActivityProvider).value ?? const [];
    final now = ref.watch(clockProvider)();

    void openApplication(int id) =>
        context.push(AppRoutes.applicationDetail(id));

    return MaxWidthContent(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          96, // Room for the FAB.
        ),
        children: [
          _Intro(
            now: now,
            interviews: interviews.length,
            deadlines: summary.upcomingDeadlines.length,
          ),
          const SizedBox(height: AppSpacing.lg),
          _StatGrid(summary: summary, upcomingInterviews: interviews.length),
          const SectionHeader('Up next'),
          _UpNextCard(
            interviews: interviews,
            deadlines: summary.upcomingDeadlines,
            now: now,
            onOpen: openApplication,
          ),
          const SectionHeader('Pipeline'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: StatusBreakdown(counts: summary.statusCounts),
            ),
          ),
          if (activity.isNotEmpty) ...[
            const SectionHeader('Recent activity'),
            _ActivityCard(
              activity: activity,
              now: now,
              onOpen: openApplication,
            ),
          ],
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro({
    required this.now,
    required this.interviews,
    required this.deadlines,
  });

  final DateTime now;
  final int interviews;
  final int deadlines;

  String get _summary {
    String plural(int n, String word) => '$n $word${n == 1 ? '' : 's'}';
    final parts = [
      if (interviews > 0) plural(interviews, 'interview'),
      if (deadlines > 0) plural(deadlines, 'deadline'),
    ];
    return parts.isEmpty
        ? 'Nothing scheduled in the next 7 days.'
        : '${parts.join(' and ')} in the next 7 days.';
  }

  @override
  Widget build(BuildContext context) {
    final muted = context.colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat.MMMMEEEEd().format(now),
          style: context.textTheme.labelLarge?.copyWith(color: muted),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(greetingFor(now), style: context.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          _summary,
          style: context.textTheme.bodyLarge?.copyWith(color: muted),
        ),
      ],
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.summary, required this.upcomingInterviews});

  final DashboardSummary summary;
  final int upcomingInterviews;

  @override
  Widget build(BuildContext context) {
    Widget row(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: b),
        ],
      ),
    );

    return Column(
      children: [
        row(
          StatTile(
            icon: Icons.work_outline,
            label: 'Active',
            value: '${summary.active}',
            caption: 'of ${summary.total} applications',
          ),
          StatTile(
            icon: Icons.send_outlined,
            label: 'This month',
            value: '${summary.appliedThisMonth}',
            caption: 'applied',
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        row(
          StatTile(
            icon: Icons.forum_outlined,
            label: 'Interviews',
            value: '$upcomingInterviews',
            caption: 'next 7 days',
          ),
          StatTile(
            icon: Icons.verified_outlined,
            label: 'Offers',
            value: '${summary.offers}',
            caption: 'received',
          ),
        ),
      ],
    );
  }
}

class _UpNextCard extends StatelessWidget {
  const _UpNextCard({
    required this.interviews,
    required this.deadlines,
    required this.now,
    required this.onOpen,
  });

  final List<UpcomingInterview> interviews;
  final List<Application> deadlines;
  final DateTime now;
  final ValueChanged<int> onOpen;

  String _interviewWhen(DateTime start) {
    final days = Formatters.daysFromToday(start, now: now);
    final day = switch (days) {
      0 => 'Today',
      1 => 'Tomorrow',
      _ => DateFormat.EEEE().format(start),
    };
    return '$day · ${DateFormat.jm().format(start)}';
  }

  @override
  Widget build(BuildContext context) {
    if (interviews.isEmpty && deadlines.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(
                Icons.event_available_outlined,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'No interviews or deadlines in the next 7 days.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final rows = <Widget>[
      for (final item in interviews)
        _UpNextRow(
          leading: DateBlock(item.interview.scheduledAt.toLocal()),
          title: item.interview.title,
          subtitle:
              '${item.companyName} · '
              '${_interviewWhen(item.interview.scheduledAt.toLocal())}',
          onTap: () => onOpen(item.applicationId),
        ),
      for (final app in deadlines)
        _UpNextRow(
          leading: _DeadlineIcon(
            urgent: Formatters.daysFromToday(app.deadlineAt!, now: now) <= 2,
          ),
          title: app.positionTitle,
          subtitle:
              '${app.companyName} · Due '
              '${Formatters.relativeDay(app.deadlineAt!, now: now)}',
          onTap: () => onOpen(app.id),
        ),
    ];

    return Card(
      child: Column(
        children: [
          for (final (index, row) in rows.indexed) ...[
            if (index > 0) const Divider(indent: AppSpacing.md),
            row,
          ],
        ],
      ),
    );
  }
}

class _UpNextRow extends StatelessWidget {
  const _UpNextRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            leading,
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.titleMedium),
                  Text(
                    subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeadlineIcon extends StatelessWidget {
  const _DeadlineIcon({required this.urgent});

  final bool urgent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final color = urgent ? colors.error : colors.tertiary;
    return SizedBox(
      width: 52,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppRadius.mdAll,
        ),
        child: Icon(Icons.flag_outlined, color: color),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.activity,
    required this.now,
    required this.onOpen,
  });

  final List<RecentStatusChange> activity;
  final DateTime now;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final muted = context.colorScheme.onSurfaceVariant;
    return Card(
      child: Column(
        children: [
          for (final (index, item) in activity.indexed) ...[
            if (index > 0) const Divider(indent: AppSpacing.md),
            InkWell(
              onTap: () => onOpen(item.applicationId),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    _StatusDot(item),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.change.fromStatus == null
                                ? 'Added as ${item.change.toStatus.label}'
                                : 'Moved to ${item.change.toStatus.label}',
                            style: context.textTheme.bodyLarge,
                          ),
                          Text(
                            '${item.positionTitle} · ${item.companyName}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      Formatters.timeAgo(item.change.changedAt, now: now),
                      style: context.textTheme.labelMedium?.copyWith(
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot(this.item);

  final RecentStatusChange item;

  @override
  Widget build(BuildContext context) {
    final status = item.change.toStatus;
    final tone = status.toneOf(context.statusColors);
    return DecoratedBox(
      decoration: BoxDecoration(color: tone.background, shape: BoxShape.circle),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Icon(status.icon, size: 18, color: tone.foreground),
      ),
    );
  }
}
