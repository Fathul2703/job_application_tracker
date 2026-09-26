import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/domain/models/status_change.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Vertical timeline of status changes, newest first.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({required this.history, super.key});

  /// Oldest first, as returned by the repository.
  final List<StatusChange> history;

  @override
  Widget build(BuildContext context) {
    final entries = history.reversed.toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Column(
        children: [
          for (final (index, change) in entries.indexed)
            _TimelineEntry(change: change, isLast: index == entries.length - 1),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.change, required this.isLast});

  final StatusChange change;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tone = change.toStatus.toneOf(context.statusColors);
    final colors = context.colorScheme;
    final title = change.fromStatus == null
        ? 'Added as ${change.toStatus.label}'
        : 'Moved to ${change.toStatus.label}';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: tone.background,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: 28,
                    child: Icon(
                      change.toStatus.icon,
                      size: 16,
                      color: tone.foreground,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xxs,
                      ),
                      color: colors.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.bodyLarge),
                  Text(
                    Formatters.timestamp(change.changedAt),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
