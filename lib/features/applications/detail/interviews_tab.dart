import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/checklist_item.dart';
import 'package:job_application_tracker/domain/models/interview.dart';
import 'package:job_application_tracker/features/applications/application_controllers.dart';
import 'package:job_application_tracker/features/interviews/widgets/interview_card.dart';
import 'package:job_application_tracker/providers/application_detail_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';

/// Upcoming and past interviews of an application.
class InterviewsTab extends ConsumerWidget {
  const InterviewsTab({required this.app, super.key});

  final Application app;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final detail = ref.read(
      applicationDetailControllerProvider(app.id).notifier,
    );
    final created = await context.push<bool>(AppRoutes.newInterview(app.id));
    if (created != true) return;

    // Scheduling an interview usually means the application moved forward.
    final rank = app.status.pipelineRank;
    final interviewRank = ApplicationStatus.interview.pipelineRank!;
    if (rank != null && rank < interviewRank) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Interview added'),
            action: SnackBarAction(
              label: 'Move to Interview',
              onPressed: () => detail.changeStatus(ApplicationStatus.interview),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interviews = ref.watch(interviewsProvider(app.id));
    final checklist = ref.watch(checklistProvider(app.id)).value ?? const [];
    final now = ref.watch(clockProvider)();

    return switch (interviews) {
      AsyncValue(value: final list?) when list.isEmpty => EmptyState(
        icon: Icons.forum_outlined,
        title: 'No interviews yet',
        message:
            'Keep dates, meeting links and outcomes of every round in one '
            'place.',
        action: FilledButton.icon(
          onPressed: () => _add(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Add interview'),
        ),
      ),
      AsyncValue(value: final list?) => _InterviewList(
        interviews: list,
        checklist: checklist,
        now: now,
        onAdd: () => _add(context, ref),
        onOpen: (interview) =>
            context.push(AppRoutes.editInterview(app.id, interview.id)),
      ),
      AsyncError(:final error) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load interviews',
        message: errorMessage(error),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _InterviewList extends StatelessWidget {
  const _InterviewList({
    required this.interviews,
    required this.checklist,
    required this.now,
    required this.onAdd,
    required this.onOpen,
  });

  /// Earliest first.
  final List<Interview> interviews;
  final List<ChecklistItem> checklist;
  final DateTime now;
  final VoidCallback onAdd;
  final ValueChanged<Interview> onOpen;

  @override
  Widget build(BuildContext context) {
    final upcoming = interviews
        .where((i) => !i.scheduledAt.isBefore(now))
        .toList();
    final past = interviews
        .where((i) => i.scheduledAt.isBefore(now))
        .toList()
        .reversed
        .toList();

    Widget card(Interview interview) {
      final prep = checklist.where((c) => c.interviewId == interview.id);
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: InterviewCard(
          interview: interview,
          now: now,
          prepTotal: prep.length,
          prepDone: prep.where((c) => c.isDone).length,
          onTap: () => onOpen(interview),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      children: [
        FilledButton.tonalIcon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add interview'),
        ),
        if (upcoming.isNotEmpty) ...[
          const SectionHeader('Upcoming'),
          ...upcoming.map(card),
        ],
        if (past.isNotEmpty) ...[
          const SectionHeader('Past'),
          ...past.map(card),
        ],
      ],
    );
  }
}
