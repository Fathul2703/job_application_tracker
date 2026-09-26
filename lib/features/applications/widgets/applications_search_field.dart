import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/features/applications/application_query_providers.dart';

/// Search box for the applications list. Typing is debounced so the
/// database is queried once the user pauses, not on every keystroke.
class ApplicationsSearchField extends ConsumerStatefulWidget {
  const ApplicationsSearchField({super.key});

  static const debounce = Duration(milliseconds: 250);

  @override
  ConsumerState<ApplicationsSearchField> createState() =>
      _ApplicationsSearchFieldState();
}

class _ApplicationsSearchFieldState
    extends ConsumerState<ApplicationsSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(applicationQueryProvider).search,
  );
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {}); // Updates the clear button.
    _debounce?.cancel();
    _debounce = Timer(
      ApplicationsSearchField.debounce,
      () => ref.read(applicationQueryProvider.notifier).setSearch(value),
    );
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    setState(() {});
    ref.read(applicationQueryProvider.notifier).setSearch('');
  }

  @override
  Widget build(BuildContext context) {
    // Stay in sync when the search is cleared elsewhere ("Clear filters").
    ref.listen(applicationQueryProvider.select((q) => q.search), (_, next) {
      if (next.isEmpty && _controller.text.isNotEmpty) {
        _controller.clear();
        setState(() {});
      }
    });

    // A TextField rather than SearchBar: SearchBar's inner field exposes a
    // 24px-tall tap target to accessibility services.
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: 'Search company, role or location',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close),
                onPressed: _clear,
              ),
        fillColor: context.colorScheme.surfaceContainerHigh,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.xlAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.xlAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.xlAll,
          borderSide: BorderSide(color: context.colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
