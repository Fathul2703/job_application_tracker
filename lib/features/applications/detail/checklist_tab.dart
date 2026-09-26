import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/checklist_item.dart';
import 'package:job_application_tracker/domain/models/interview.dart';
import 'package:job_application_tracker/features/applications/detail/detail_controllers.dart';
import 'package:job_application_tracker/providers/application_detail_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/text_input_sheet.dart';

/// Interview-preparation checklist with quick add, reordering and links to
/// specific interviews.
class ChecklistTab extends ConsumerStatefulWidget {
  const ChecklistTab({required this.app, super.key});

  final Application app;

  static const suggestions = [
    'Research the company',
    'Review the job description',
    'Prepare STAR stories',
    'Prepare questions to ask',
    'Test camera and microphone',
  ];

  @override
  ConsumerState<ChecklistTab> createState() => _ChecklistTabState();
}

class _ChecklistTabState extends ConsumerState<ChecklistTab> {
  final _addController = TextEditingController();
  final _addFocus = FocusNode();

  /// Order shown right after a drag, until the database confirms it. Avoids
  /// items jumping back for a frame.
  List<ChecklistItem>? _optimistic;

  int get _appId => widget.app.id;

  ChecklistController get _controller =>
      ref.read(checklistControllerProvider(_appId).notifier);

  @override
  void dispose() {
    _addController.dispose();
    _addFocus.dispose();
    super.dispose();
  }

  Future<void> _add(String title) async {
    if (title.trim().isEmpty) return;
    if (await _controller.add(title)) {
      _addController.clear();
      _addFocus.requestFocus();
    }
  }

  /// [newIndex] is already adjusted for the removed item (`onReorderItem`).
  void _reorder(List<ChecklistItem> items, int oldIndex, int newIndex) {
    final reordered = [...items];
    reordered.insert(newIndex, reordered.removeAt(oldIndex));
    setState(() => _optimistic = reordered);
    unawaited(_controller.reorder([for (final item in reordered) item.id]));
  }

  Future<void> _rename(ChecklistItem item) async {
    final title = await showTextInputSheet(
      context,
      title: 'Rename task',
      hintText: 'Task',
      initialText: item.title,
    );
    if (title != null) await _controller.rename(item.id, title);
  }

  Future<void> _link(ChecklistItem item, List<Interview> interviews) async {
    // Wrapped so "Not linked" (null) can be told apart from dismissing.
    final choice = await showDialog<({int? id})>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Prepare for'),
        children: [
          for (final interview in interviews)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop((id: interview.id)),
              child: Text(interview.title),
            ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop((id: null)),
            child: const Text('Not linked to an interview'),
          ),
        ],
      ),
    );
    if (choice != null) await _controller.linkToInterview(item.id, choice.id);
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(checklistProvider(_appId), (_, next) {
        if (next.hasValue && _optimistic != null) {
          setState(() => _optimistic = null);
        }
      })
      ..listen(checklistControllerProvider(_appId), (_, next) {
        if (next case AsyncError(:final error)) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(errorMessage(error))));
        }
      });

    final items = _optimistic ?? ref.watch(checklistProvider(_appId)).value;
    final interviews = ref.watch(interviewsProvider(_appId)).value ?? const [];

    return Column(
      children: [
        Expanded(
          child: switch (items) {
            null => const Center(child: CircularProgressIndicator()),
            [] => _EmptyChecklist(onSuggestion: _add),
            _ => ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
              ),
              buildDefaultDragHandles: false,
              header: _Progress(items: items),
              itemCount: items.length,
              onReorderItem: (from, to) => _reorder(items, from, to),
              itemBuilder: (context, index) {
                final item = items[index];
                final interviewTitle = interviews
                    .where((i) => i.id == item.interviewId)
                    .firstOrNull
                    ?.title;
                return _ChecklistTile(
                  key: ValueKey(item.id),
                  index: index,
                  item: item,
                  interviewTitle: interviewTitle,
                  onToggle: () =>
                      _controller.setDone(item.id, isDone: !item.isDone),
                  onRename: () => _rename(item),
                  onLink: interviews.isEmpty
                      ? null
                      : () => _link(item, interviews),
                  onDelete: () => _controller.delete(item.id),
                );
              },
            ),
          },
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: TextField(
              controller: _addController,
              focusNode: _addFocus,
              decoration: const InputDecoration(
                hintText: 'Add a task',
                prefixIcon: Icon(Icons.add),
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onSubmitted: _add,
            ),
          ),
        ),
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.items});

  final List<ChecklistItem> items;

  @override
  Widget build(BuildContext context) {
    final done = items.where((i) => i.isDone).length;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$done of ${items.length} done',
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadius.smAll,
            child: LinearProgressIndicator(
              value: items.isEmpty ? 0 : done / items.length,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.index,
    required this.item,
    required this.onToggle,
    required this.onRename,
    required this.onDelete,
    this.interviewTitle,
    this.onLink,
    super.key,
  });

  final int index;
  final ChecklistItem item;
  final String? interviewTitle;
  final VoidCallback onToggle;
  final VoidCallback onRename;
  final VoidCallback? onLink;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: AppSpacing.xxs),
          horizontalTitleGap: AppSpacing.xxs,
          minVerticalPadding: AppSpacing.sm,
          leading: Checkbox(value: item.isDone, onChanged: (_) => onToggle()),
          title: Text(
            item.title,
            style: item.isDone
                ? context.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  )
                : context.textTheme.bodyLarge,
          ),
          subtitle: interviewTitle == null
              ? null
              : Text(
                  'For $interviewTitle',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.primary,
                  ),
                ),
          onTap: onToggle,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<VoidCallback>(
                tooltip: 'Task options',
                padding: EdgeInsets.zero,
                onSelected: (action) => action(),
                itemBuilder: (_) => [
                  PopupMenuItem(value: onRename, child: const Text('Rename')),
                  if (onLink case final link?)
                    PopupMenuItem(
                      value: link,
                      child: const Text('Link to interview'),
                    ),
                  PopupMenuItem(value: onDelete, child: const Text('Delete')),
                ],
              ),
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    AppSpacing.sm,
                    AppSpacing.sm,
                    AppSpacing.sm,
                  ),
                  child: Icon(
                    Icons.drag_handle,
                    semanticLabel: 'Reorder',
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyChecklist extends StatelessWidget {
  const _EmptyChecklist({required this.onSuggestion});

  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.lg),
        Icon(
          Icons.checklist,
          size: 40,
          color: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Prepare with a checklist',
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Add your own tasks below, or start with a suggestion.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final suggestion in ChecklistTab.suggestions)
              ActionChip(
                avatar: const Icon(Icons.add),
                label: Text(suggestion),
                onPressed: () => onSuggestion(suggestion),
              ),
          ],
        ),
      ],
    );
  }
}
