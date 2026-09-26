import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/services/analytics.dart';

/// Applied → Response → Interview → Offer as horizontal bars from a shared
/// baseline, each labelled with its count and share of applications sent.
class Funnel extends StatelessWidget {
  const Funnel({required this.report, super.key});

  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final stages = [
      ('Applied', Rate(report.submitted, report.submitted)),
      ('Response', report.responseRate),
      ('Interview', report.interviewRate),
      ('Offer', report.offerRate),
    ];

    return Column(
      children: [
        for (final (index, (label, rate)) in stages.indexed)
          Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.sm),
            child: _FunnelRow(label: label, rate: rate, isBase: index == 0),
          ),
      ],
    );
  }
}

class _FunnelRow extends StatelessWidget {
  const _FunnelRow({
    required this.label,
    required this.rate,
    required this.isBase,
  });

  static const _labelWidth = 80.0;
  static const _valueWidth = 72.0;
  static const _barHeight = 20.0;

  final String label;
  final Rate rate;
  final bool isBase;

  @override
  Widget build(BuildContext context) {
    final fraction = rate.value ?? 0;
    final percent = '${(fraction * 100).round()}%';
    final valueText = isBase ? '${rate.count}' : '${rate.count} · $percent';
    final textStyle = context.textTheme.bodyMedium;

    return Semantics(
      label: isBase
          ? '$label: ${rate.count}'
          : '$label: ${rate.count} of ${rate.total}, $percent',
      excludeSemantics: true,
      child: Row(
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text(label, style: textStyle),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth * fraction;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    // A zero count still shows a sliver at the baseline.
                    width: width < 2 ? 2 : width,
                    height: _barHeight,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      // Square at the baseline, rounded at the data end.
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(4),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: _valueWidth,
            child: Text(
              valueText,
              style: textStyle?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
