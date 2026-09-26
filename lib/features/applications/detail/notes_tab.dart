import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/note.dart';
import 'package:job_application_tracker/features/applications/detail/detail_controllers.dart';
import 'package:job_application_tracker/providers/application_detail_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/confirm_dialog.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/text_input_sheet.dart';

/// Free-form notes of an application, newest first.
class NotesTab extends ConsumerWidget {
  const NotesTab({required this.app, super.key});

  final Application app;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(notesControllerProvider(app.id).notifier);
    final content = await showTextInputSheet(
      context,
      title: 'New note',
      hintText: 'Recruiter contact, salary talk, impressions…',
      multiline: true,
    );
    if (content != null) await controller.add(content);
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Note note) async {
    final controller = ref.read(notesControllerProvider(app.id).notifier);
    final content = await showTextInputSheet(
      context,
      title: 'Edit note',
      hintText: 'Note',
      initialText: note.content,
      multiline: true,
    );
    if (content != null && content != note.content) {
      await controller.edit(note.id, content);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Note note) async {
    final controller = ref.read(notesControllerProvider(app.id).notifier);
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete note?',
      message: 'This note will be permanently deleted.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (confirmed) await controller.delete(note.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(notesControllerProvider(app.id), (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(errorMessage(error))));
      }
    });

    return switch (ref.watch(notesProvider(app.id))) {
      AsyncValue(value: final notes?) when notes.isEmpty => EmptyState(
        icon: Icons.sticky_note_2_outlined,
        title: 'No notes yet',
        message: 'Capture recruiter contacts, salary talks and impressions.',
        action: FilledButton.icon(
          onPressed: () => _add(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Add note'),
        ),
      ),
      AsyncValue(value: final notes?) => ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: [
          FilledButton.tonalIcon(
            onPressed: () => _add(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Add note'),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final note in notes)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _NoteCard(
                note: note,
                onEdit: () => _edit(context, ref, note),
                onDelete: () => _delete(context, ref, note),
              ),
            ),
        ],
      ),
      AsyncError(:final error) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load notes',
        message: errorMessage(error),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final edited = note.updatedAt != note.createdAt;
    final meta = [
      Formatters.timestamp(note.createdAt),
      if (edited) 'Edited',
    ].join(' · ');

    return Card(
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xxs,
            AppSpacing.xxs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Text(note.content, style: context.textTheme.bodyLarge),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      meta,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Delete note',
                    color: context.colorScheme.onSurfaceVariant,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
