import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Stacked horizontal bar of applications per status, with a legend.
/// Statuses with no applications are left out.
class PipelineBar extends StatelessWidget {
  const PipelineBar({required this.counts, super.key});

  /// Count per status, in pipeline order.
  final Map<ApplicationStatus, int> counts;

  @override
  Widget build(BuildContext context) {
    final entries = counts.entries.where((e) => e.value > 0).toList();
    final statusColors = context.statusColors;
    final description = entries
        .map((e) => '${e.value} ${e.key.label.toLowerCase()}')
        .join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: 'Pipeline: $description',
          excludeSemantics: true,
          child: ClipRRect(
            borderRadius: AppRadius.smAll,
            child: SizedBox(
              height: 12,
              child: Row(
                // Segments fill the bar's height.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (index, entry) in entries.indexed)
                    Expanded(
                      flex: entry.value,
                      child: Padding(
                        // A hairline gap keeps adjacent colors distinct.
                        padding: EdgeInsets.only(
                          right: index == entries.length - 1 ? 0 : 2,
                        ),
                        child: ColoredBox(
                          color: entry.key.toneOf(statusColors).foreground,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: [
            for (final entry in entries)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: entry.key.toneOf(statusColors).foreground,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 8),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${entry.key.label} ${entry.value}',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
