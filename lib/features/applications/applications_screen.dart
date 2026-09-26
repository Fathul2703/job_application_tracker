import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_application_tracker/core/router/app_router.dart';
import 'package:job_application_tracker/core/theme/design_tokens.dart';
import 'package:job_application_tracker/core/theme/theme_context.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/domain/models/application_query.dart';
import 'package:job_application_tracker/features/applications/application_query_providers.dart';
import 'package:job_application_tracker/features/applications/widgets/application_card.dart';
import 'package:job_application_tracker/features/applications/widgets/application_filter_sheet.dart';
import 'package:job_application_tracker/features/applications/widgets/applications_search_field.dart';
import 'package:job_application_tracker/features/applications/widgets/no_applications_state.dart';
import 'package:job_application_tracker/features/applications/widgets/status_filter_bar.dart';
import 'package:job_application_tracker/providers/application_providers.dart';
import 'package:job_application_tracker/providers/data_providers.dart';
import 'package:job_application_tracker/shared/error_message.dart';
import 'package:job_application_tracker/shared/widgets/empty_state.dart';
import 'package:job_application_tracker/shared/widgets/max_width_content.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applications = ref.watch(applicationsProvider);
    final hasApplications = applications.value?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        actions: hasApplications
            ? const [_SortButton(), _FilterButton(), SizedBox(width: 4)]
            : null,
      ),
      floatingActionButton: hasApplications
          ? FloatingActionButton.extended(
              // Both tabs stay mounted (IndexedStack) and each has a FAB; the
              // default shared hero tag would clash when pushing a route.
              heroTag: null,
              onPressed: () => context.push(AppRoutes.newApplication),
              icon: const Icon(Icons.add),
              label: const Text('New'),
            )
          : null,
      body: switch (applications) {
        AsyncValue(value: final list?) when list.isEmpty =>
          const NoApplicationsState(),
        AsyncValue(value: final list?) => _SearchableApplications(list),
        AsyncError(:final error) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load applications',
          message: errorMessage(error),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _SortButton extends ConsumerWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(applicationQueryProvider.select((q) => q.sort));
    return PopupMenuButton<ApplicationSort>(
      tooltip: 'Sort',
      icon: const Icon(Icons.sort),
      initialValue: sort,
      onSelected: ref.read(applicationQueryProvider.notifier).setSort,
      itemBuilder: (_) => [
        for (final option in ApplicationSort.values)
          CheckedPopupMenuItem(
            value: option,
            checked: option == sort,
            child: Text(option.label),
          ),
      ],
    );
  }
}

class _FilterButton extends ConsumerWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      applicationQueryProvider.select((q) => q.filterCount),
    );
    return IconButton(
      tooltip: count == 0 ? 'Filters' : 'Filters ($count active)',
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.tune),
      ),
      onPressed: () => showApplicationFilterSheet(context),
    );
  }
}

/// Search, status chips and the filtered list.
class _SearchableApplications extends ConsumerWidget {
  const _SearchableApplications(this.all);

  /// Every application, unfiltered.
  final List<Application> all;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredApplicationsProvider);

    return MaxWidthContent(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xxs,
              AppSpacing.md,
              AppSpacing.xxs,
            ),
            child: ApplicationsSearchField(),
          ),
          StatusFilterBar(applications: all),
          Expanded(
            // Keeps showing the previous results while a new query runs.
            child: switch (filtered) {
              AsyncValue(value: final results?) when results.isEmpty =>
                const _NoMatches(),
              AsyncValue(value: final results?) => _ApplicationList(
                results: results,
                total: all.length,
                active: all.where((a) => !a.status.isTerminal).length,
              ),
              AsyncError(:final error) => EmptyState(
                icon: Icons.error_outline,
                title: 'Could not load applications',
                message: errorMessage(error),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

class _ApplicationList extends ConsumerWidget {
  const _ApplicationList({
    required this.results,
    required this.total,
    required this.active,
  });

  final List<Application> results;
  final int total;
  final int active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider)();
    final query = ref.watch(applicationQueryProvider);

    final summary = query.isFiltering
        ? 'Showing ${results.length} of $total'
        : '$total ${total == 1 ? 'application' : 'applications'}'
              ' · $active active';

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      // Leaves room for the FAB below the last card.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        96,
      ),
      itemCount: results.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _ListSummary(
            text: summary,
            sortLabel: query.sort == ApplicationSort.recentlyUpdated
                ? null
                : query.sort.label,
            onClear: query.isFiltering
                ? ref.read(applicationQueryProvider.notifier).clearAll
                : null,
          );
        }
        final app = results[index - 1];
        return ApplicationCard(
          key: ValueKey(app.id),
          application: app,
          now: now,
          onTap: () => context.push(AppRoutes.applicationDetail(app.id)),
        );
      },
    );
  }
}

class _ListSummary extends StatelessWidget {
  const _ListSummary({required this.text, this.sortLabel, this.onClear});

  final String text;
  final String? sortLabel;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.labelLarge?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.xxs),
          Expanded(
            child: Text(
              [
                text,
                if (sortLabel != null) 'by ${sortLabel!.toLowerCase()}',
              ].join(' · '),
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onClear != null)
            TextButton(onPressed: onClear, child: const Text('Clear')),
        ],
      ),
    );
  }
}

class _NoMatches extends ConsumerWidget {
  const _NoMatches();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No matching applications',
      message: 'Try a different search or clear the filters.',
      action: OutlinedButton(
        onPressed: ref.read(applicationQueryProvider.notifier).clearAll,
        child: const Text('Clear search and filters'),
      ),
    );
  }
}
