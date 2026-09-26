import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/features/applications/application_controllers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';

/// Shown when there are no applications at all: add one, or (debug builds)
/// load demo data.
class NoApplicationsState extends ConsumerWidget {
  const NoApplicationsState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingDemo = ref.watch(demoDataControllerProvider).isLoading;
    ref.listen(demoDataControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(errorMessage(error))));
      }
    });

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
