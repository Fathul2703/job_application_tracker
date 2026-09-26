import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/services/analytics.dart';

/// Applications sent per month as columns, split into "got a response"
/// (primary) and "no response yet" (muted step of the same hue).
///
/// Follows the dataviz mark specs: one axis, columns ≤ 24px with a 4px
/// rounded data end, a 2px surface gap between stacked segments, hairline
/// recessive grid, a legend, and a tooltip on touch. The monthly table below
/// the chart is its table view.
class MonthlyChart extends StatelessWidget {
  const MonthlyChart({required this.months, super.key});

  final List<MonthStats> months;

  static const _height = 200.0;
  static const _bottomReserved = 28.0;
  static const _leftReserved = 28.0;

  /// A clean tick step for [max] applications.
  static int _interval(int max) => switch (max) {
    <= 4 => 1,
    <= 10 => 2,
    _ => (max / 5).ceil(),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final muted = context.chartColors.primaryMuted;
    final axisStyle = context.textTheme.labelSmall?.copyWith(
      color: colors.onSurfaceVariant,
    );

    final maxApplied = months.map((m) => m.applied).fold(0, math.max);
    final interval = _interval(maxApplied);
    final maxY = math.max(interval, (maxApplied / interval).ceil() * interval);
    // 2px expressed in data units, for the gap between stacked segments.
    final gap = 2 * maxY / (_height - _bottomReserved);

    final description = months
        .map(
          (m) =>
              '${DateFormat.MMM().format(m.month)}: ${m.applied} sent, '
              '${m.responses} with a response',
        )
        .join('; ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Applications per month. $description',
          excludeSemantics: true,
          child: SizedBox(
            height: _height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final slot =
                    (constraints.maxWidth - _leftReserved) / months.length;
                final barWidth = math.min(24.0, slot * 0.6);

                return BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: maxY.toDouble(),
                    alignment: BarChartAlignment.spaceAround,
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: interval.toDouble(),
                      getDrawingHorizontalLine: (_) =>
                          FlLine(color: colors.outlineVariant, strokeWidth: 1),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: colors.outlineVariant),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: _leftReserved,
                          interval: interval.toDouble(),
                          getTitlesWidget: (value, meta) => SideTitleWidget(
                            meta: meta,
                            child: Text('${value.toInt()}', style: axisStyle),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: _bottomReserved,
                          getTitlesWidget: (value, meta) => SideTitleWidget(
                            meta: meta,
                            child: Text(
                              DateFormat.MMM().format(
                                months[value.toInt()].month,
                              ),
                              style: axisStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => colors.inverseSurface,
                        getTooltipItem: (group, _, _, _) {
                          final m = months[group.x];
                          return BarTooltipItem(
                            '${DateFormat.yMMM().format(m.month)}\n'
                            '${m.applied} sent · ${m.responses} responded',
                            TextStyle(color: colors.onInverseSurface),
                          );
                        },
                      ),
                    ),
                    barGroups: [
                      for (final (i, m) in months.indexed)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: m.applied.toDouble(),
                              width: barWidth,
                              color: Colors.transparent,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                              rodStackItems: [
                                if (m.responses > 0)
                                  BarChartRodStackItem(
                                    0,
                                    m.responses.toDouble(),
                                    colors.primary,
                                  ),
                                if (m.applied > m.responses)
                                  BarChartRodStackItem(
                                    m.responses == 0
                                        ? 0
                                        : m.responses.toDouble() + gap,
                                    m.applied.toDouble(),
                                    muted,
                                  ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: [
            _LegendItem(color: colors.primary, label: 'Got a response'),
            _LegendItem(color: muted, label: 'No response yet'),
          ],
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: const SizedBox.square(dimension: 10),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: context.textTheme.bodySmall),
      ],
    );
  }
}
