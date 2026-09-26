import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Bottom sheet for choosing a status. Resolves to the chosen status, or
/// `null` when dismissed.
Future<ApplicationStatus?> showStatusPicker(
  BuildContext context, {
  required ApplicationStatus current,
}) {
  return showModalBottomSheet<ApplicationStatus>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _StatusPickerSheet(current: current),
  );
}

class _StatusPickerSheet extends StatelessWidget {
  const _StatusPickerSheet({required this.current});

  final ApplicationStatus current;

  @override
  Widget build(BuildContext context) {
    final pipeline = ApplicationStatus.values.where((s) => !s.isTerminal);
    final closed = ApplicationStatus.values.where((s) => s.isTerminal);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xs,
            ),
            child: Text('Change status', style: context.textTheme.titleLarge),
          ),
          for (final status in pipeline) _StatusOption(status, current),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: Divider(),
          ),
          for (final status in closed) _StatusOption(status, current),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption(this.status, this.current);

  final ApplicationStatus status;
  final ApplicationStatus current;

  @override
  Widget build(BuildContext context) {
    final tone = status.toneOf(context.statusColors);
    final selected = status == current;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: ListTile(
        selected: selected,
        selectedTileColor: context.colorScheme.secondaryContainer.withValues(
          alpha: 0.5,
        ),
        leading: DecoratedBox(
          decoration: BoxDecoration(
            color: tone.background,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Icon(status.icon, size: 20, color: tone.foreground),
          ),
        ),
        title: Text(status.label),
        subtitle: Text(status.description),
        trailing: selected ? const Icon(Icons.check) : null,
        onTap: () => Navigator.of(context).pop(status),
      ),
    );
  }
}
