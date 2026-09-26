import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/services/analytics.dart';
import 'package:job_application_tracker/features/analytics/analytics_providers.dart';
import 'package:job_application_tracker/features/analytics/widgets/funnel.dart';
import 'package:job_application_tracker/features/analytics/widgets/monthly_chart.dart';
import 'package:job_application_tracker/features/analytics/widgets/monthly_table.dart';
import 'package:job_application_tracker/features/applications/widgets/no_applications_state.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/content_app_bar.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';
import 'package:job_application_tracker/shared/widgets/stat_tile.dart';
import 'package:job_application_tracker/shared/widgets/status_breakdown.dart';

/// How the job search is going: rates, funnel, monthly trend and status mix
/// for a selectable period.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasApplications =
        ref.watch(applicationsProvider).value?.isNotEmpty ?? false;
    final report = ref.watch(analyticsReportProvider);

    return Scaffold(
      appBar: const ContentAppBar(title: Text('Analytics')),
      body: switch (report) {
        AsyncValue(value: _?) when !hasApplications =>
          const NoApplicationsState(),
        AsyncValue(value: final data?) => _AnalyticsBody(report: data),
        AsyncError(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load analytics',
          message: errorMessage(error),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _AnalyticsBody extends ConsumerWidget {
  const _AnalyticsBody({required this.report});

  final AnalyticsReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(analyticsPeriodProvider);

    return MaxWidthContent(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: [
          SegmentedButton<AnalyticsPeriod>(
            showSelectedIcon: false,
            segments: [
              for (final option in AnalyticsPeriod.values)
                ButtonSegment(value: option, label: Text(option.label)),
            ],
            selected: {period},
            onSelectionChanged: (selection) => ref
                .read(analyticsPeriodProvider.notifier)
                .select(selection.first),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (report.submitted == 0)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: EmptyState(
                  icon: Icons.insights_outlined,
                  title: 'No applications sent in this period',
                  message:
                      'Rates appear once an application has an applied '
                      'date in the selected period.',
                ),
              ),
            )
          else ...[
            _RateGrid(report: report),
            const SectionHeader('Funnel'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Funnel(report: report),
                    if (report.medianDaysToResponse case final days?) ...[
                      const SizedBox(height: AppSpacing.md),
                      const Divider(),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Typical wait for a first response: '
                        '$days ${days == 1 ? 'day' : 'days'} (median)',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SectionHeader('Applications per month'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: MonthlyChart(months: report.months),
              ),
            ),
          ],
          const SectionHeader('Current status'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: StatusBreakdown(counts: report.statusCounts),
            ),
          ),
          if (report.submitted > 0) ...[
            SectionHeader(
              'Monthly statistics',
              trailing: report.monthsTruncated
                  ? Text(
                      'Last ${Analytics.maxMonths} months',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    )
                  : null,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: MonthlyTable(months: report.months),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RateGrid extends StatelessWidget {
  const _RateGrid({required this.report});

  final AnalyticsReport report;

  static String _percent(Rate rate) => switch (rate.value) {
    null => '–',
    final v => '${(v * 100).round()}%',
  };

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

    StatTile rateTile(IconData icon, String label, Rate rate) => StatTile(
      icon: icon,
      label: label,
      value: _percent(rate),
      caption: '${rate.count} of ${rate.total} sent',
    );

    return Column(
      children: [
        row(
          StatTile(
            icon: Icons.send_outlined,
            label: 'Sent',
            value: '${report.submitted}',
            caption: report.submitted == 1 ? 'application' : 'applications',
          ),
          rateTile(
            Icons.mark_email_read_outlined,
            'Response rate',
            report.responseRate,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        row(
          rateTile(
            Icons.forum_outlined,
            'Interview rate',
            report.interviewRate,
          ),
          rateTile(Icons.verified_outlined, 'Offer rate', report.offerRate),
        ),
      ],
    );
  }
}
