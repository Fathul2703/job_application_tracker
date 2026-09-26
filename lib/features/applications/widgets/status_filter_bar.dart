import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/application_query_providers.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Horizontally scrolling status chips with counts. Only statuses that
/// occur (or are selected) are shown, so the row stays short.
class StatusFilterBar extends ConsumerWidget {
  const StatusFilterBar({required this.applications, super.key});

  /// All applications (unfiltered), used for the counts.
  final List<Application> applications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      applicationQueryProvider.select((q) => q.statuses),
    );
    final counts = <ApplicationStatus, int>{};
    for (final app in applications) {
      counts.update(app.status, (n) => n + 1, ifAbsent: () => 1);
    }
    final statuses = ApplicationStatus.values
        .where((s) => counts.containsKey(s) || selected.contains(s))
        .toList();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: statuses.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = selected.contains(status);
          final tone = status.toneOf(context.statusColors);
          return Center(
            child: FilterChip(
              showCheckmark: false,
              avatar: Icon(
                status.icon,
                size: 16,
                color: isSelected ? tone.foreground : null,
              ),
              label: Text('${status.label} ${counts[status] ?? 0}'),
              labelStyle: isSelected ? TextStyle(color: tone.foreground) : null,
              selected: isSelected,
              selectedColor: tone.background,
              side: isSelected ? BorderSide(color: tone.foreground) : null,
              onSelected: (_) => ref
                  .read(applicationQueryProvider.notifier)
                  .toggleStatus(status),
            ),
          );
        },
      ),
    );
  }
}
