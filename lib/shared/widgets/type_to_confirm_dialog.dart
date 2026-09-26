import 'package:flutter/material.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';

/// A destructive confirmation that only enables its button once the user
/// has typed [phrase] exactly. Resolves to `true` when confirmed.
Future<bool> showTypeToConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String phrase = 'DELETE',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => _TypeToConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      phrase: phrase,
    ),
  );
  return confirmed ?? false;
}

class _TypeToConfirmDialog extends StatefulWidget {
  const _TypeToConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.phrase,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String phrase;

  @override
  State<_TypeToConfirmDialog> createState() => _TypeToConfirmDialogState();
}

class _TypeToConfirmDialogState extends State<_TypeToConfirmDialog> {
  final _controller = TextEditingController();

  bool get _matches => _controller.text.trim() == widget.phrase;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            autocorrect: false,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'Type ${widget.phrase} to confirm',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
          ),
          onPressed: _matches ? () => Navigator.of(context).pop(true) : null,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
