import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';
import 'package:job_application_tracker/core/utils/strings.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/features/applications/application_controllers.dart';
import 'package:job_application_tracker/features/applications/widgets/form_fields.dart';
import 'package:job_application_tracker/features/applications/widgets/status_picker_sheet.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/confirm_dialog.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';
import 'package:job_application_tracker/shared/widgets/section_header.dart';
import 'package:job_application_tracker/shared/widgets/status_chip.dart';

/// Loads an application and shows the form pre-filled for editing.
class EditApplicationScreen extends ConsumerWidget {
  const EditApplicationScreen({required this.applicationId, super.key});

  final int applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final application = ref.watch(applicationProvider(applicationId));

    return switch (application) {
      AsyncData(value: final app?) => ApplicationFormScreen(
        key: ValueKey(app.id),
        initial: app,
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          icon: Icons.search_off,
          title: 'Application not found',
          message: 'It may have been deleted.',
        ),
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load application',
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

/// Create (no [initial]) or edit form for an application.
class ApplicationFormScreen extends ConsumerStatefulWidget {
  const ApplicationFormScreen({this.initial, super.key});

  final Application? initial;

  @override
  ConsumerState<ApplicationFormScreen> createState() =>
      _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends ConsumerState<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final ApplicationDraft _initialDraft;
  late final TextEditingController _company;
  late final TextEditingController _position;
  late final TextEditingController _location;
  late final TextEditingController _salaryMin;
  late final TextEditingController _salaryMax;
  late final TextEditingController _currency;
  late final TextEditingController _jobUrl;

  late ApplicationStatus _status;
  WorkMode? _workMode;
  EmploymentType? _employmentType;
  late SalaryPeriod _salaryPeriod;
  DateTime? _appliedAt;
  DateTime? _deadlineAt;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final draft =
        widget.initial?.toDraft() ??
        const ApplicationDraft(companyName: '', positionTitle: '');
    _initialDraft = draft;

    String salaryText(int? value) =>
        value == null ? '' : Formatters.groupedDigits(value);

    _company = TextEditingController(text: draft.companyName);
    _position = TextEditingController(text: draft.positionTitle);
    _location = TextEditingController(text: draft.location ?? '');
    _salaryMin = TextEditingController(text: salaryText(draft.salaryMin));
    _salaryMax = TextEditingController(text: salaryText(draft.salaryMax));
    _currency = TextEditingController(text: draft.salaryCurrency);
    _jobUrl = TextEditingController(text: draft.jobUrl ?? '');
    _status = draft.status;
    _workMode = draft.workMode;
    _employmentType = draft.employmentType;
    _salaryPeriod = draft.salaryPeriod ?? SalaryPeriod.monthly;
    _appliedAt = draft.appliedAt;
    _deadlineAt = draft.deadlineAt;
  }

  @override
  void dispose() {
    for (final controller in [
      _company,
      _position,
      _location,
      _salaryMin,
      _salaryMax,
      _currency,
      _jobUrl,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  ApplicationDraft _currentDraft() {
    final salaryMin = ThousandsSeparatorInputFormatter.parse(_salaryMin.text);
    final salaryMax = ThousandsSeparatorInputFormatter.parse(_salaryMax.text);
    final hasSalary = salaryMin != null || salaryMax != null;
    return ApplicationDraft(
      companyName: _company.text.trim(),
      positionTitle: _position.text.trim(),
      location: _location.text.trimmedOrNull,
      workMode: _workMode,
      employmentType: _employmentType,
      salaryMin: salaryMin,
      salaryMax: salaryMax,
      salaryCurrency: _currency.text.trim().toUpperCase(),
      salaryPeriod: hasSalary ? _salaryPeriod : null,
      jobUrl: _jobUrl.text.trimmedOrNull,
      status: _status,
      appliedAt: _appliedAt,
      deadlineAt: _deadlineAt,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final id = await ref
        .read(applicationFormControllerProvider.notifier)
        .save(_currentDraft(), id: widget.initial?.id);
    if (id == null || !mounted) return;

    if (_isEditing) {
      Navigator.of(context).pop();
    } else {
      context.go(AppRoutes.applicationDetail(id));
    }
  }

  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    if (didPop) return;
    final navigator = Navigator.of(context);
    final unchanged = _currentDraft() == _initialDraft;
    if (unchanged ||
        await showConfirmDialog(
          context,
          title: 'Discard changes?',
          message: 'Your changes to this application will be lost.',
          confirmLabel: 'Discard',
          destructive: true,
        )) {
      navigator.pop();
    }
  }

  Future<void> _pickStatus() async {
    final picked = await showStatusPicker(context, current: _status);
    if (picked != null) setState(() => _status = picked);
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(applicationFormControllerProvider).isLoading;
    ref.listen(applicationFormControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(errorMessage(error))));
      }
    });

    final now = DateTime.now();
    final showAppliedDate =
        _status != ApplicationStatus.saved || _appliedAt != null;

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
          title: Text(_isEditing ? 'Edit application' : 'New application'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: FilledButton(
                onPressed: saving ? null : _save,
                child: saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
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
                const SectionHeader('Role'),
                TextFormField(
                  controller: _company,
                  decoration: const InputDecoration(
                    labelText: 'Company *',
                    prefixIcon: Icon(Icons.business_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofocus: !_isEditing,
                  validator: (value) =>
                      ApplicationDraft.validateCompany(value ?? ''),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _position,
                  decoration: const InputDecoration(
                    labelText: 'Position *',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      ApplicationDraft.validatePosition(value ?? ''),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _location,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                ChoiceChipGroup<WorkMode>(
                  label: 'Work mode',
                  values: WorkMode.values,
                  labelOf: (v) => v.label,
                  selected: _workMode,
                  onChanged: (v) => setState(() => _workMode = v),
                ),
                const SizedBox(height: AppSpacing.md),
                ChoiceChipGroup<EmploymentType>(
                  label: 'Employment type',
                  values: EmploymentType.values,
                  labelOf: (v) => v.label,
                  selected: _employmentType,
                  onChanged: (v) => setState(() => _employmentType = v),
                ),

                const SectionHeader('Status & dates'),
                PickerField(
                  label: 'Status',
                  icon: Icons.flag_outlined,
                  onTap: _pickStatus,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: StatusChip(_status),
                  ),
                ),
                if (showAppliedDate) ...[
                  const SizedBox(height: AppSpacing.md),
                  DateField(
                    label: 'Applied on',
                    icon: Icons.send_outlined,
                    value: _appliedAt,
                    helperText: _appliedAt == null
                        ? 'Defaults to today when saved'
                        : null,
                    firstDate: DateTime(2000),
                    lastDate: now,
                    onChanged: (v) => setState(() => _appliedAt = v),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                DateField(
                  label: 'Deadline',
                  icon: Icons.event_outlined,
                  value: _deadlineAt,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(now.year + 5),
                  onChanged: (v) => setState(() => _deadlineAt = v),
                ),

                const SectionHeader('Salary'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _salaryField(_salaryMin, 'Minimum')),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _salaryField(_salaryMax, 'Maximum')),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 104,
                      child: TextFormField(
                        controller: _currency,
                        decoration: const InputDecoration(
                          labelText: 'Currency',
                          counterText: '',
                        ),
                        maxLength: 3,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                          const UpperCaseTextFormatter(),
                        ],
                        validator: (value) => ApplicationDraft.validateCurrency(
                          (value ?? '').trim().toUpperCase(),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SegmentedButton<SalaryPeriod>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: SalaryPeriod.monthly,
                            label: Text('Monthly'),
                          ),
                          ButtonSegment(
                            value: SalaryPeriod.yearly,
                            label: Text('Yearly'),
                          ),
                        ],
                        selected: {_salaryPeriod},
                        onSelectionChanged: (s) =>
                            setState(() => _salaryPeriod = s.first),
                      ),
                    ),
                  ],
                ),

                const SectionHeader('Job posting'),
                TextFormField(
                  controller: _jobUrl,
                  decoration: const InputDecoration(
                    labelText: 'Link',
                    hintText: 'https://',
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  validator: ApplicationDraft.validateJobUrl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _salaryField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(13),
        const ThousandsSeparatorInputFormatter(),
      ],
      validator: (_) => identical(controller, _salaryMax)
          ? ApplicationDraft.validateSalaryRange(
              ThousandsSeparatorInputFormatter.parse(_salaryMin.text),
              ThousandsSeparatorInputFormatter.parse(_salaryMax.text),
            )
          : null,
    );
  }
}
