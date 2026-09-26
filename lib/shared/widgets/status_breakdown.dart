import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/app_typography.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Applications per status as labelled rows in pipeline order: icon, name,
/// a single-hue bar sized by count, and the count.
///
/// Replaces a stacked multi-color bar: the status palette is built for
/// text-on-tint chips and fails categorical chart checks (CVD separation,
/// dark-mode lightness), so identity here is carried by the label, not by
/// color. Statuses with no applications are left out.
class StatusBreakdown extends StatelessWidget {
  const StatusBreakdown({required this.counts, super.key});

  /// Count per status, in pipeline order.
  final Map<ApplicationStatus, int> counts;

  static const _labelWidth = 128.0;
  static const _countWidth = 32.0;
  static const _barHeight = 8.0;

  @override
  Widget build(BuildContext context) {
    final entries = counts.entries.where((e) => e.value > 0).toList();
    final maxCount = entries.map((e) => e.value).fold(0, math.max);
    final colors = context.colorScheme;

    return Column(
      children: [
        for (final (index, entry) in entries.indexed)
          Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.sm),
            child: Semantics(
              label:
                  '${entry.key.label}: ${entry.value} '
                  '${entry.value == 1 ? 'application' : 'applications'}',
              excludeSemantics: true,
              child: Row(
                children: [
                  SizedBox(
                    width: _labelWidth,
                    child: Row(
                      children: [
                        Icon(
                          entry.key.icon,
                          size: 16,
                          color: entry.key
                              .toneOf(context.statusColors)
                              .foreground,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            entry.key.label,
                            style: context.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: constraints.maxWidth * entry.value / maxCount,
                          height: _barHeight,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            // Square at the baseline, rounded at the data end.
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _countWidth,
                    child: Text(
                      '${entry.value}',
                      textAlign: TextAlign.end,
                      style: context.textTheme.bodyMedium?.tabular.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
