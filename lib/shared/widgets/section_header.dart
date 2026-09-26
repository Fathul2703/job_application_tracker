import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';

/// Small label above a group of related content.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxs,
        AppSpacing.lg,
        AppSpacing.xxs,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
