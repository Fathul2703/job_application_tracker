import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_application_tracker/domain/models/application.dart';
import 'package:job_application_tracker/providers/data_providers.dart';

import '../helpers/test_database.dart';

void main() {
  test('repositories use the overridden database and clock', () async {
    final clock = FakeClock.standard();
    final container = ProviderContainer.test(
      overrides: [
        appDatabaseProvider.overrideWithValue(createTestDatabase()),
        clockProvider.overrideWithValue(clock.call),
      ],
    );

    final repo = container.read(applicationRepositoryProvider);
    final id = await repo.create(
      const ApplicationDraft(companyName: 'Acme', positionTitle: 'Dev'),
    );

    final app = (await repo.getById(id))!;
    expect(app.createdAt, clock.now.toUtc());
  });
}
