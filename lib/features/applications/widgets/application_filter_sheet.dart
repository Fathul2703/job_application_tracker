import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/features/applications/application_query_providers.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Filters apply live, so the button can show the resulting count.
Future<void> showApplicationFilterSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    // Covers the navigation bar instead of opening inside the tab.
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => const _ApplicationFilterSheet(),
  );
}

class _ApplicationFilterSheet extends ConsumerWidget {
  const _ApplicationFilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(applicationQueryProvider);
    final controller = ref.read(applicationQueryProvider.notifier);
    final results = ref.watch(filteredApplicationsProvider).value?.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Filters', style: context.textTheme.titleLarge),
              ),
              TextButton(
                onPressed: query.filterCount > 0
                    ? controller.clearFilters
                    : null,
                child: const Text('Clear'),
              ),
            ],
          ),
          _FilterSection<ApplicationStatus>(
            title: 'Status',
            values: ApplicationStatus.values,
            selected: query.statuses,
            labelOf: (s) => s.label,
            iconOf: (s) => s.icon,
            onToggle: controller.toggleStatus,
          ),
          _FilterSection<WorkMode>(
            title: 'Work mode',
            values: WorkMode.values,
            selected: query.workModes,
            labelOf: (m) => m.label,
            onToggle: controller.toggleWorkMode,
          ),
          _FilterSection<EmploymentType>(
            title: 'Employment type',
            values: EmploymentType.values,
            selected: query.employmentTypes,
            labelOf: (t) => t.label,
            onToggle: controller.toggleEmploymentType,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(switch (results) {
              null => 'Show results',
              1 => 'Show 1 result',
              final n => 'Show $n results',
            }),
          ),
        ],
      ),
    );
  }
}

class _FilterSection<T> extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onToggle,
    this.iconOf,
  });

  final String title;
  final List<T> values;
  final Set<T> selected;
  final String Function(T) labelOf;
  final IconData Function(T)? iconOf;
  final ValueChanged<T> onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final value in values)
                FilterChip(
                  avatar: switch (iconOf) {
                    final icon? when !selected.contains(value) => Icon(
                      icon(value),
                      size: 16,
                    ),
                    _ => null,
                  },
                  label: Text(labelOf(value)),
                  selected: selected.contains(value),
                  onSelected: (_) => onToggle(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
