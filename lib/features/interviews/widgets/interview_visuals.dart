import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/status_colors.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';

extension InterviewFormatVisuals on InterviewFormat {
  IconData get icon => switch (this) {
    InterviewFormat.phone => Icons.call_outlined,
    InterviewFormat.video => Icons.videocam_outlined,
    InterviewFormat.onsite => Icons.apartment_outlined,
  };
}

extension InterviewOutcomeVisuals on InterviewOutcome {
  IconData get icon => switch (this) {
    InterviewOutcome.pending => Icons.schedule,
    InterviewOutcome.passed => Icons.check,
    InterviewOutcome.failed => Icons.close,
    InterviewOutcome.cancelled => Icons.block,
  };

  /// Reuses the status palette so outcome colors match the rest of the app.
  StatusTone toneOf(BuildContext context) {
    final colors = context.statusColors;
    return switch (this) {
      InterviewOutcome.pending => colors.saved,
      InterviewOutcome.passed => colors.offer,
      InterviewOutcome.failed => colors.rejected,
      InterviewOutcome.cancelled => colors.withdrawn,
    };
  }
}

/// Small pill for an interview outcome.
class OutcomeChip extends StatelessWidget {
  const OutcomeChip(this.outcome, {super.key});

  final InterviewOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final tone = outcome.toneOf(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: AppRadius.smAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(outcome.icon, size: 14, color: tone.foreground),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              outcome.label,
              style: context.textTheme.labelMedium?.copyWith(
                color: tone.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
