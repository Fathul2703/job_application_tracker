import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/core/utils/date_only.dart';
import 'package:job_application_tracker/core/utils/formatters.dart';

/// A read-only field that opens a picker when tapped, styled like the other
/// text fields.
class PickerField extends StatelessWidget {
  const PickerField({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.child,
    this.onClear,
    this.helperText,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Widget child;

  /// Shows a clear button when set.
  final VoidCallback? onClear;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          prefixIcon: Icon(icon),
          suffixIcon: onClear == null
              ? null
              : IconButton(
                  tooltip: 'Clear $label',
                  icon: const Icon(Icons.close),
                  onPressed: onClear,
                ),
        ),
        child: child,
      ),
    );
  }
}

/// Picks a calendar date; the value is date-only (see `DateOnly`).
class DateField extends StatelessWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.icon = Icons.event_outlined,
    this.helperText,
    super.key,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final IconData icon;
  final String? helperText;

  Future<void> _pick(BuildContext context) async {
    final current = value;
    final initial = current == null
        ? DateTime.now()
        : DateTime(current.year, current.month, current.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate) || initial.isAfter(lastDate)
          ? firstDate
          : initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) onChanged(picked.toDateOnly());
  }

  @override
  Widget build(BuildContext context) {
    final current = value;
    return PickerField(
      label: label,
      icon: icon,
      helperText: helperText,
      onTap: () => _pick(context),
      onClear: current == null ? null : () => onChanged(null),
      child: Text(
        current == null ? 'Not set' : Formatters.date(current),
        style: current == null
            ? context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              )
            : context.textTheme.bodyLarge,
      ),
    );
  }
}

/// Single-choice chips where tapping the selected chip clears the value.
class ChoiceChipGroup<T> extends StatelessWidget {
  const ChoiceChipGroup({
    required this.label,
    required this.values,
    required this.labelOf,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String label;
  final List<T> values;
  final String Function(T) labelOf;
  final T? selected;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
              ChoiceChip(
                label: Text(labelOf(value)),
                selected: value == selected,
                onSelected: (isSelected) =>
                    onChanged(isSelected ? value : null),
              ),
          ],
        ),
      ],
    );
  }
}

/// Digits only, grouped with thousands separators: "12,000,000".
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  const ThousandsSeparatorInputFormatter();

  /// Parses a value produced by this formatter back to an int.
  static int? parse(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? null : int.tryParse(digits);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final number = parse(newValue.text);
    if (number == null) return TextEditingValue.empty;
    final formatted = Formatters.groupedDigits(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}
