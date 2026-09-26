import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/strings.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/interview.dart';
import 'package:job_application_tracker/features/interviews/interview_controllers.dart';
import 'package:job_application_tracker/features/interviews/widgets/interview_visuals.dart';
import 'package:job_application_tracker/providers/application_detail_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/confirm_dialog.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/form_fields.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';

/// Loads an interview and shows the form pre-filled for editing.
class EditInterviewScreen extends ConsumerWidget {
  const EditInterviewScreen({
    required this.applicationId,
    required this.interviewId,
    super.key,
  });

  final int applicationId;
  final int interviewId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(interviewProvider(interviewId))) {
      AsyncData(value: final interview?) => InterviewFormScreen(
        key: ValueKey(interview.id),
        applicationId: applicationId,
        initial: interview,
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.search_off,
          title: 'Interview not found',
          message: 'It may have been deleted.',
        ),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load interview',
          message: errorMessage(error),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

/// Create (no [initial]) or edit form for an interview. Pops with `true`
/// after creating, so the caller can react (e.g. suggest a status change).
class InterviewFormScreen extends ConsumerStatefulWidget {
  const InterviewFormScreen({
    required this.applicationId,
    this.initial,
    super.key,
  });

  final int applicationId;
  final Interview? initial;

  static const titleSuggestions = [
    'HR Interview',
    'User Interview',
    'Technical Interview',
    'Final Interview',
  ];

  @override
  ConsumerState<InterviewFormScreen> createState() =>
      _InterviewFormScreenState();
}

class _InterviewFormScreenState extends ConsumerState<InterviewFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final InterviewDraft _initialDraft;
  late final TextEditingController _title;
  late final TextEditingController _duration;
  late final TextEditingController _location;
  late final TextEditingController _interviewer;
  late final TextEditingController _summary;

  late InterviewFormat _format;
  late DateTime _date;
  late TimeOfDay _time;
  late InterviewOutcome _outcome;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final now = ref.read(clockProvider)();
    // New interviews default to tomorrow at 10:00.
    final defaultStart = DateTime(now.year, now.month, now.day + 1, 10);
    final draft =
        widget.initial?.toDraft() ??
        InterviewDraft(
          title: '',
          format: InterviewFormat.video,
          scheduledAt: defaultStart,
          durationMinutes: 60,
        );
    _initialDraft = draft;

    final start = draft.scheduledAt.toLocal();
    _title = TextEditingController(text: draft.title);
    _duration = TextEditingController(
      text: draft.durationMinutes?.toString() ?? '',
    );
    _location = TextEditingController(text: draft.location ?? '');
    _interviewer = TextEditingController(text: draft.interviewer ?? '');
    _summary = TextEditingController(text: draft.summary ?? '');
    _format = draft.format;
    _date = DateTime(start.year, start.month, start.day);
    _time = TimeOfDay.fromDateTime(start);
    _outcome = draft.outcome;
  }

  @override
  void dispose() {
    for (final controller in [
      _title,
      _duration,
      _location,
      _interviewer,
      _summary,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  InterviewDraft _currentDraft() => InterviewDraft(
    title: _title.text.trim(),
    format: _format,
    scheduledAt: DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    ),
    durationMinutes: int.tryParse(_duration.text),
    location: _location.text.trimmedOrNull,
    interviewer: _interviewer.text.trimmedOrNull,
    outcome: _outcome,
    summary: _summary.text.trimmedOrNull,
  );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    final id = await ref
        .read(interviewFormControllerProvider.notifier)
        .save(widget.applicationId, _currentDraft(), id: widget.initial?.id);
    if (id == null || !mounted) return;
    navigator.pop(!_isEditing);
  }

  Future<void> _delete() async {
    final interview = widget.initial;
    if (interview == null) return;
    final navigator = Navigator.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete interview?',
      message:
          '${interview.title} and the checklist items linked to it will be '
          'deleted.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final deleted = await ref
        .read(interviewFormControllerProvider.notifier)
        .delete(interview.id);
    if (deleted && mounted) navigator.pop();
  }

  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    if (didPop) return;
    final navigator = Navigator.of(context);
    if (_currentDraft() == _initialDraft ||
        await showConfirmDialog(
          context,
          title: 'Discard changes?',
          message: 'Your changes to this interview will be lost.',
          confirmLabel: 'Discard',
          destructive: true,
        )) {
      navigator.pop();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(_date.year + 5),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(interviewFormControllerProvider).isLoading;
    ref.listen(interviewFormControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(errorMessage(error))));
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(_isEditing ? 'Edit interview' : 'New interview'),
          actions: [
            if (_isEditing)
              IconButton(
                tooltip: 'Delete interview',
                icon: const Icon(Icons.delete_outline),
                onPressed: saving ? null : _delete,
              ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: FilledButton(
                onPressed: saving ? null : _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: MaxWidthContent(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.xxl,
              ),
              children: [
                const SectionHeader('Round'),
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    prefixIcon: Icon(Icons.forum_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  autofocus: !_isEditing,
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Title is required.'
                      : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final suggestion
                        in InterviewFormScreen.titleSuggestions)
                      ActionChip(
                        label: Text(suggestion),
                        onPressed: () =>
                            setState(() => _title.text = suggestion),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<InterviewFormat>(
                  segments: [
                    for (final format in InterviewFormat.values)
                      ButtonSegment(
                        value: format,
                        icon: Icon(format.icon),
                        label: Text(format.label),
                      ),
                  ],
                  selected: {_format},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => setState(() => _format = s.first),
                ),

                const SectionHeader('When'),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PickerField(
                        label: 'Date',
                        icon: Icons.event_outlined,
                        onTap: _pickDate,
                        child: Text(
                          DateFormat.yMMMEd().format(_date),
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: PickerField(
                        label: 'Time',
                        icon: Icons.schedule,
                        onTap: _pickTime,
                        child: Text(
                          _time.format(context),
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _duration,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    suffixText: 'min',
                    prefixIcon: Icon(Icons.timelapse),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    final minutes = int.tryParse(value ?? '');
                    return minutes != null && minutes <= 0
                        ? 'Duration must be greater than zero.'
                        : null;
                  },
                ),

                const SectionHeader('Details'),
                TextFormField(
                  controller: _location,
                  decoration: InputDecoration(
                    labelText: switch (_format) {
                      InterviewFormat.video => 'Meeting link',
                      InterviewFormat.onsite => 'Address',
                      InterviewFormat.phone => 'Phone number',
                    },
                    prefixIcon: Icon(_format.icon),
                  ),
                  keyboardType: _format == InterviewFormat.video
                      ? TextInputType.url
                      : TextInputType.text,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _interviewer,
                  decoration: const InputDecoration(
                    labelText: 'Interviewer',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),

                const SectionHeader('Outcome'),
                ChoiceChipGroup<InterviewOutcome>(
                  label: 'Result',
                  values: InterviewOutcome.values,
                  labelOf: (o) => o.label,
                  selected: _outcome,
                  // An outcome is always set; tapping the selected chip is a no-op.
                  onChanged: (o) {
                    if (o != null) setState(() => _outcome = o);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _summary,
                  decoration: const InputDecoration(
                    labelText: 'Summary',
                    hintText: 'Questions asked, feedback, next steps',
                    alignLabelWithHint: true,
                  ),
                  minLines: 3,
                  maxLines: 8,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
