import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/widgets/application_display.dart';
import 'package:job_application_tracker/shared/widgets/company_avatar.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Summary card for one application in the list.
class ApplicationCard extends StatelessWidget {
  const ApplicationCard({
    required this.application,
    required this.now,
    required this.onTap,
    super.key,
  });

  final Application application;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final app = application;
    final colors = context.colorScheme;
    final location = app.locationSummary;
    final meta = [
      if (location.isNotEmpty) location,
      ?Formatters.salary(
        min: app.salaryMin,
        max: app.salaryMax,
        currency: app.salaryCurrency,
        period: app.salaryPeriod,
        compact: true,
      ),
    ].join(' · ');
    final (dateLabel, isUrgent) = _dateInfo(app, now);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyAvatar(app.companyName),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.positionTitle,
                      style: context.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      app.companyName,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        meta,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        StatusChip(app.status),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            dateLabel,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.labelMedium?.copyWith(
                              color: isUrgent
                                  ? colors.error
                                  : colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
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

  /// The most useful date to show, and whether it needs attention.
  static (String, bool) _dateInfo(Application app, DateTime now) {
    final deadline = app.deadlineAt;
    if (deadline != null && !app.status.isTerminal) {
      final days = Formatters.daysFromToday(deadline, now: now);
      if (days >= 0 && days <= 7) {
        return ('Due ${Formatters.relativeDay(deadline, now: now)}', days <= 2);
      }
      if (days < 0 && app.status == ApplicationStatus.saved) {
        return ('Deadline passed', true);
      }
    }
    final applied = app.appliedAt;
    if (applied != null) {
      return ('Applied ${Formatters.shortDate(applied, now: now)}', false);
    }
    final created = app.createdAt.toLocal();
    return ('Saved ${Formatters.shortDate(created, now: now)}', false);
  }
}
