import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';

/// Bottom sheet with a single text field. Resolves to the trimmed text when
/// saved, or `null` when dismissed. Save is disabled while the text is blank.
Future<String?> showTextInputSheet(
  BuildContext context, {
  required String title,
  required String hintText,
  String initialText = '',
  String confirmLabel = 'Save',
  bool multiline = false,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _TextInputSheet(
      title: title,
      hintText: hintText,
      initialText: initialText,
      confirmLabel: confirmLabel,
      multiline: multiline,
    ),
  );
}

class _TextInputSheet extends StatefulWidget {
  const _TextInputSheet({
    required this.title,
    required this.hintText,
    required this.initialText,
    required this.confirmLabel,
    required this.multiline,
  });

  final String title;
  final String hintText;
  final String initialText;
  final String confirmLabel;
  final bool multiline;

  @override
  State<_TextInputSheet> createState() => _TextInputSheetState();
}

class _TextInputSheetState extends State<_TextInputSheet> {
  late final _controller = TextEditingController(text: widget.initialText);

  bool get _canSave => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_canSave) Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Keeps the field above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: context.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(hintText: widget.hintText),
              minLines: widget.multiline ? 4 : 1,
              maxLines: widget.multiline ? 10 : 1,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: widget.multiline
                  ? TextInputAction.newline
                  : TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onSubmitted: widget.multiline ? null : (_) => _save(),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _canSave ? _save : null,
              child: Text(widget.confirmLabel),
            ),
          ],
        ),
      ),
    );
  }
}
