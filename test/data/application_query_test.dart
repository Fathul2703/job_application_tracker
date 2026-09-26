import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/data/repositories/application_repository.dart';
import 'package:job_application_tracker/domain/enums/application_status.dart';
import 'package:job_application_tracker/domain/enums/job_enums.dart';
import 'package:job_application_tracker/domain/models/application_query.dart';

import '../helpers/query_fixtures.dart';
import '../helpers/test_database.dart';

void main() {
  late ApplicationRepository repo;

  setUp(() async {
    final db = createTestDatabase();
    await seedQueryFixtures(db);
    repo = ApplicationRepository(db);
  });

  Future<List<String>> companies(ApplicationQuery query) async =>
      (await repo.watchAll(query: query).first)
          .map((a) => a.companyName)
          .toList();

  test('default query returns everything, most recently updated first', () {
    expect(
      companies(const ApplicationQuery()),
      completion([
        '100% Remote Co',
        'kopi kode',
        'Sagara Labs',
        'Arunika Digital',
      ]),
    );
  });

  group('search', () {
    test('matches position case-insensitively', () {
      expect(
        companies(const ApplicationQuery(search: 'DEVELOPER')),
        completion(['kopi kode', 'Sagara Labs', 'Arunika Digital']),
      );
    });

    test('matches location', () {
      expect(
        companies(const ApplicationQuery(search: 'bandung')),
        completion(['Sagara Labs']),
      );
    });

    test('every word must match some field', () {
      expect(
        companies(const ApplicationQuery(search: '  flutter   jakarta ')),
        completion(['Arunika Digital']),
      );
      expect(
        companies(const ApplicationQuery(search: 'flutter bandung')),
        completion(isEmpty),
      );
    });

    test('treats % and _ literally', () {
      expect(
        companies(const ApplicationQuery(search: '%')),
        completion(['100% Remote Co']),
      );
      expect(
        companies(const ApplicationQuery(search: '_')),
        completion(['100% Remote Co']),
      );
    });
  });

  group('filters', () {
    test('statuses are OR-ed', () {
      expect(
        companies(
          const ApplicationQuery(
            statuses: {ApplicationStatus.applied, ApplicationStatus.interview},
          ),
        ),
        completion(['Sagara Labs', 'Arunika Digital']),
      );
    });

    test('different filters are AND-ed', () {
      expect(
        companies(const ApplicationQuery(workModes: {WorkMode.remote})),
        completion(['100% Remote Co', 'Sagara Labs']),
      );
      expect(
        companies(
          const ApplicationQuery(
            workModes: {WorkMode.remote},
            employmentTypes: {EmploymentType.internship},
          ),
        ),
        completion(['100% Remote Co']),
      );
    });

    test('combines with search', () {
      expect(
        companies(
          const ApplicationQuery(
            search: 'developer',
            workModes: {WorkMode.remote},
          ),
        ),
        completion(['Sagara Labs']),
      );
    });
  });

  group('sort', () {
    test('applied date: latest first, not applied last', () {
      expect(
        companies(const ApplicationQuery(sort: ApplicationSort.appliedDate)),
        completion([
          'Sagara Labs',
          'Arunika Digital',
          '100% Remote Co',
          'kopi kode',
        ]),
      );
    });

    test('deadline: soonest first, none last', () {
      expect(
        companies(const ApplicationQuery(sort: ApplicationSort.deadline)),
        completion([
          'kopi kode',
          'Sagara Labs',
          '100% Remote Co',
          'Arunika Digital',
        ]),
      );
    });

    test('company: case-insensitive A–Z', () {
      expect(
        companies(const ApplicationQuery(sort: ApplicationSort.company)),
        completion([
          '100% Remote Co',
          'Arunika Digital',
          'kopi kode',
          'Sagara Labs',
        ]),
      );
    });
  });
}
