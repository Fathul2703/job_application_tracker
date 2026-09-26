import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/application_controllers.dart';
import 'package:job_application_tracker/features/applications/detail/checklist_tab.dart';
import 'package:job_application_tracker/features/applications/detail/interviews_tab.dart';
import 'package:job_application_tracker/features/applications/detail/notes_tab.dart';
import 'package:job_application_tracker/features/applications/detail/overview_tab.dart';
import 'package:job_application_tracker/features/applications/widgets/status_picker_sheet.dart';
import 'package:job_application_tracker/providers/application_detail_providers.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/company_avatar.dart';
import 'package:job_application_tracker/shared/widgets/confirm_dialog.dart';
import 'package:job_application_tracker/shared/widgets/content_app_bar.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

class ApplicationDetailScreen extends ConsumerStatefulWidget {
  const ApplicationDetailScreen({required this.applicationId, super.key});

  final int applicationId;

  @override
  ConsumerState<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState
    extends ConsumerState<ApplicationDetailScreen> {
  /// Set while deleting, so the brief "not found" state is not shown before
  /// navigating away.
  bool _deleting = false;

  ApplicationDetailController get _controller => ref.read(
    applicationDetailControllerProvider(widget.applicationId).notifier,
  );

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _changeStatus(Application app) async {
    final picked = await showStatusPicker(context, current: app.status);
    if (picked == null || picked == app.status) return;
    if (await _controller.changeStatus(picked)) {
      unawaited(HapticFeedback.selectionClick());
      if (mounted) _showMessage('Moved to ${picked.label}');
    }
  }

  Future<void> _delete(Application app) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete application?',
      message:
          '${app.positionTitle} at ${app.companyName} will be deleted with '
          'its interviews, checklist and notes. This cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    setState(() => _deleting = true);
    final deleted = await _controller.delete();
    if (!mounted) return;
    if (deleted) {
      _showMessage('Application deleted');
      context.go(AppRoutes.applications);
    } else {
      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = widget.applicationId;
    ref.listen(applicationDetailControllerProvider(id), (_, next) {
      if (next case AsyncError(:final error)) _showMessage(errorMessage(error));
    });

    return switch (ref.watch(applicationProvider(id))) {
      AsyncData(value: final app?) => _buildDetail(app),
      AsyncData() when _deleting => const Scaffold(),
      AsyncData() => Scaffold(
        appBar: const ContentAppBar(),
        body: EmptyState(
          icon: Icons.search_off,
          title: 'Application not found',
          message: 'It may have been deleted.',
          action: FilledButton(
            onPressed: () => context.go(AppRoutes.applications),
            child: const Text('Back to applications'),
          ),
        ),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: const ContentAppBar(),
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load application',
          message: errorMessage(error),
        ),
      ),
      _ => const Scaffold(
        appBar: ContentAppBar(),
        body: Center(child: CircularProgressIndicator()),
      ),
    };
  }

  Widget _buildDetail(Application app) {
    final busy = ref
        .watch(applicationDetailControllerProvider(app.id))
        .isLoading;
    final interviewCount =
        ref.watch(interviewsProvider(app.id)).value?.length ?? 0;
    final checklist = ref.watch(checklistProvider(app.id)).value ?? const [];
    final noteCount = ref.watch(notesProvider(app.id)).value?.length ?? 0;
    final checklistDone = checklist.where((c) => c.isDone).length;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: ContentAppBar(
          actions: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(AppRoutes.editApplication(app.id)),
            ),
            PopupMenuButton<void>(
              tooltip: 'More',
              itemBuilder: (_) => [
                PopupMenuItem(
                  onTap: () => _delete(app),
                  child: const ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Delete'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        body: MaxWidthContent(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: _Header(app: app),
              ),
              // Fixed tabs so all four stay visible on phones; counts are
              // overlaid badges and don't add width.
              TabBar(
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxs,
                ),
                tabs: [
                  const Tab(text: 'Overview'),
                  _CountTab(
                    label: 'Interviews',
                    count: interviewCount == 0 ? null : '$interviewCount',
                  ),
                  _CountTab(
                    label: 'Checklist',
                    count: checklist.isEmpty
                        ? null
                        : '$checklistDone/${checklist.length}',
                  ),
                  _CountTab(
                    label: 'Notes',
                    count: noteCount == 0 ? null : '$noteCount',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    OverviewTab(
                      app: app,
                      busy: busy,
                      onChangeStatus: () => _changeStatus(app),
                    ),
                    InterviewsTab(app: app),
                    ChecklistTab(app: app),
                    NotesTab(app: app),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.app});

  final Application app;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CompanyAvatar(app.companyName, size: 48),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app.positionTitle,
                style: context.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                app.companyName,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        StatusChip(app.status),
      ],
    );
  }
}

/// Tab label with a small count badge overlaid on its top-right corner.
class _CountTab extends StatelessWidget {
  const _CountTab({required this.label, this.count});

  final String label;
  final String? count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Tab(
      child: Badge(
        isLabelVisible: count != null,
        label: Text(count ?? ''),
        backgroundColor: colors.secondaryContainer,
        textColor: colors.onSecondaryContainer,
        offset: const Offset(14, -8),
        child: Text(label, maxLines: 1, softWrap: false),
      ),
    );
  }
}
