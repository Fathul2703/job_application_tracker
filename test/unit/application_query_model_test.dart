import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/application_query.dart';
import 'package:job_application_tracker/features/applications/application_query_providers.dart';

void main() {
  group('ApplicationQuery', () {
    test('splits search into lowercase terms', () {
      expect(
        const ApplicationQuery(search: '  Flutter   JAKARTA ').searchTerms,
        ['flutter', 'jakarta'],
      );
      expect(const ApplicationQuery(search: '   ').searchTerms, isEmpty);
    });

    test('counts filters and detects filtering', () {
      const plain = ApplicationQuery(sort: ApplicationSort.company);
      expect(plain.filterCount, 0);
      expect(plain.isFiltering, isFalse);

      const filtered = ApplicationQuery(
        statuses: {ApplicationStatus.offer},
        workModes: {WorkMode.remote, WorkMode.hybrid},
      );
      expect(filtered.filterCount, 3);
      expect(filtered.isFiltering, isTrue);
      expect(const ApplicationQuery(search: 'x').isFiltering, isTrue);
    });

    test('equality ignores set order', () {
      expect(
        const ApplicationQuery(
          statuses: {ApplicationStatus.offer, ApplicationStatus.applied},
        ),
        const ApplicationQuery(
          statuses: {ApplicationStatus.applied, ApplicationStatus.offer},
        ),
      );
    });

    test('cleared keeps the sort order', () {
      const query = ApplicationQuery(
        search: 'x',
        statuses: {ApplicationStatus.offer},
        sort: ApplicationSort.deadline,
      );
      expect(
        query.cleared(),
        const ApplicationQuery(sort: ApplicationSort.deadline),
      );
    });
  });

  group('ApplicationQueryController', () {
    test('toggles values and clears filters but keeps search and sort', () {
      final container = ProviderContainer.test();
      final controller = container.read(applicationQueryProvider.notifier)
        ..setSearch('flutter')
        ..setSort(ApplicationSort.company)
        ..toggleStatus(ApplicationStatus.offer)
        ..toggleWorkMode(WorkMode.remote)
        ..toggleEmploymentType(EmploymentType.contract);

      expect(container.read(applicationQueryProvider).filterCount, 3);

      controller.toggleStatus(ApplicationStatus.offer);
      expect(container.read(applicationQueryProvider).statuses, isEmpty);

      controller.clearFilters();
      expect(
        container.read(applicationQueryProvider),
        const ApplicationQuery(
          search: 'flutter',
          sort: ApplicationSort.company,
        ),
      );

      controller.clearAll();
      expect(
        container.read(applicationQueryProvider),
        const ApplicationQuery(sort: ApplicationSort.company),
      );
    });
  });
}
