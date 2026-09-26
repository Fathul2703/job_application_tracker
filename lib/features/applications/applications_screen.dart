import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/application_controllers.dart';
import 'package:job_application_tracker/features/applications/widgets/application_card.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsProvider);
    final hasApplications = applications.value?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Applications')),
      floatingActionButton: hasApplications
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutes.newApplication),
              icon: const Icon(Icons.add),
              label: const Text('New'),
            )
          : null,
      body: switch (applications) {
        AsyncData(value: final list) when list.isEmpty =>
          const _EmptyApplications(),
        AsyncData(value: final list) => _ApplicationList(list),
        AsyncError(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load applications',
          message: errorMessage(error),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ApplicationList extends ConsumerWidget {
  const _ApplicationList(this.applications);

  final List<Application> applications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider)();
    final active = applications.where((a) => !a.status.isTerminal).length;
    final total = applications.length;

    return MaxWidthContent(
      child: ListView.separated(
        // Leaves room for the FAB below the last card.
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          96,
        ),
        itemCount: applications.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              child: Text(
                '$total ${total == 1 ? 'application' : 'applications'}'
                ' · $active active',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }
          final app = applications[index - 1];
          return ApplicationCard(
            key: ValueKey(app.id),
            application: app,
            now: now,
            onTap: () => context.push(AppRoutes.applicationDetail(app.id)),
          );
        },
      ),
    );
  }
}

class _EmptyApplications extends ConsumerWidget {
  const _EmptyApplications();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingDemo = ref.watch(demoDataControllerProvider).isLoading;

    return EmptyState(
      icon: Icons.work_outline,
      title: 'No applications yet',
      message:
          'Track every role you save or apply for, from first click to '
          'final offer.',
      action: Column(
        children: [
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.newApplication),
            icon: const Icon(Icons.add),
            label: const Text('Add application'),
          ),
          // Development aid for trying the app and taking screenshots.
          if (kDebugMode) ...[
            const SizedBox(height: AppSpacing.xs),
            TextButton.icon(
              onPressed: loadingDemo
                  ? null
                  : () => ref.read(demoDataControllerProvider.notifier).load(),
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text('Load demo data'),
            ),
          ],
        ],
      ),
    );
  }
}
