import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/app_typography.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';

/// A labelled number with an optional caption, e.g. "Active / 8 / of 13".
class StatTile extends StatelessWidget {
  const StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.caption,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final muted = context.colorScheme.onSurfaceVariant;
    return Card(
      child: Semantics(
        label: [label, value, ?caption].join(', '),
        excludeSemantics: true,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: muted),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      label,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: muted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(value, style: context.textTheme.headlineMedium?.tabular),
              if (caption != null)
                Text(
                  caption!,
                  style: context.textTheme.bodySmall?.copyWith(color: muted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
