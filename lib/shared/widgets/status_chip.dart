import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/status_colors.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';

/// Icon and theme colors for each [ApplicationStatus]. Status is always shown
/// with both, never color alone.
extension ApplicationStatusVisuals on ApplicationStatus {
  IconData get icon => switch (this) {
    ApplicationStatus.saved => Icons.bookmark_border,
    ApplicationStatus.applied => Icons.send_outlined,
    ApplicationStatus.screening => Icons.fact_check_outlined,
    ApplicationStatus.interview => Icons.forum_outlined,
    ApplicationStatus.technicalTest => Icons.code,
    ApplicationStatus.offer => Icons.verified_outlined,
    ApplicationStatus.rejected => Icons.close,
    ApplicationStatus.withdrawn => Icons.undo,
  };

  String get description => switch (this) {
    ApplicationStatus.saved => 'Not applied yet',
    ApplicationStatus.applied => 'Application sent',
    ApplicationStatus.screening => 'Recruiter review or HR call',
    ApplicationStatus.interview => 'Interview rounds in progress',
    ApplicationStatus.technicalTest => 'Take-home or live coding',
    ApplicationStatus.offer => 'Offer received',
    ApplicationStatus.rejected => 'Not moving forward',
    ApplicationStatus.withdrawn => 'You withdrew',
  };

  StatusTone toneOf(StatusColors colors) => switch (this) {
    ApplicationStatus.saved => colors.saved,
    ApplicationStatus.applied => colors.applied,
    ApplicationStatus.screening => colors.screening,
    ApplicationStatus.interview => colors.interview,
    ApplicationStatus.technicalTest => colors.technicalTest,
    ApplicationStatus.offer => colors.offer,
    ApplicationStatus.rejected => colors.rejected,
    ApplicationStatus.withdrawn => colors.withdrawn,
  };
}

/// Compact pill showing a status with its icon and color.
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {this.onTap, super.key});

  final ApplicationStatus status;

  /// When set, the chip shows a dropdown affordance and is tappable.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tone = status.toneOf(context.statusColors);
    final textStyle = context.textTheme.labelMedium?.copyWith(
      color: tone.foreground,
    );

    return Semantics(
      button: onTap != null,
      label: 'Status: ${status.label}',
      excludeSemantics: true,
      child: Material(
        color: tone.background,
        borderRadius: AppRadius.smAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.smAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(status.icon, size: 14, color: tone.foreground),
                const SizedBox(width: AppSpacing.xxs),
                Text(status.label, style: textStyle),
                if (onTap != null) ...[
                  const SizedBox(width: 2),
                  Icon(Icons.expand_more, size: 16, color: tone.foreground),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
