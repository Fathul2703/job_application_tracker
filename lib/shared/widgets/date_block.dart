import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';

/// Month and day in a tinted square, e.g. "SEP / 28".
class DateBlock extends StatelessWidget {
  const DateBlock(this.date, {super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    return SizedBox(
      width: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.1),
          borderRadius: AppRadius.mdAll,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            children: [
              Text(
                DateFormat.MMM().format(date).toUpperCase(),
                style: context.textTheme.labelSmall?.copyWith(color: primary),
              ),
              Text(
                '${date.day}',
                style: context.textTheme.titleLarge?.copyWith(color: primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
