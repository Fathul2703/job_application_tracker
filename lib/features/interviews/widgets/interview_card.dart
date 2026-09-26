import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/domain/models/interview.dart';
import 'package:job_application_tracker/features/interviews/widgets/interview_visuals.dart';
import 'package:job_application_tracker/shared/open_link.dart';
import 'package:job_application_tracker/shared/widgets/date_block.dart';

/// One interview: date block, title, time, where, who and prep progress.
class InterviewCard extends StatelessWidget {
  const InterviewCard({
    required this.interview,
    required this.now,
    required this.onTap,
    this.prepDone = 0,
    this.prepTotal = 0,
    super.key,
  });

  final Interview interview;
  final DateTime now;
  final VoidCallback onTap;

  /// Checklist items linked to this interview.
  final int prepDone;
  final int prepTotal;

  String _when(DateTime start) {
    final days = Formatters.daysFromToday(start, now: now);
    final day = switch (days) {
      0 => 'Today',
      1 => 'Tomorrow',
      -1 => 'Yesterday',
      _ => DateFormat.EEEE().format(start),
    };
    final duration = interview.durationMinutes;
    return [
      day,
      DateFormat.jm().format(start),
      if (duration != null) '$duration min',
    ].join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final start = interview.scheduledAt.toLocal();
    final location = interview.location;
    final muted = context.textTheme.bodyMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateBlock(start),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            interview.title,
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        OutcomeChip(interview.outcome),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(_when(start), style: muted),
                    const SizedBox(height: AppSpacing.xs),
                    _MetaLine(
                      icon: interview.format.icon,
                      child: location != null && isWebLink(location)
                          ? InkWell(
                              onTap: () => openLink(context, location),
                              child: Text(
                                'Join meeting',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: colors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: colors.primary,
                                ),
                              ),
                            )
                          : Text(
                              location ?? interview.format.label,
                              style: muted,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    if (interview.interviewer case final interviewer?)
                      _MetaLine(
                        icon: Icons.person_outline,
                        child: Text(interviewer, style: muted),
                      ),
                    if (prepTotal > 0)
                      _MetaLine(
                        icon: Icons.checklist,
                        child: Text(
                          '$prepDone of $prepTotal prep tasks done',
                          style: muted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxs),
      child: Row(
        children: [
          Icon(icon, size: 16, color: context.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.xs),
          Flexible(child: child),
        ],
      ),
    );
  }
}
