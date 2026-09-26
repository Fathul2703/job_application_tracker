# Job Tracker — CLAUDE.md

## Project purpose

**Job Tracker** is a personal, local-first mobile app for managing a job search:
companies, positions, application status, interviews, interview-prep checklists,
notes and analytics. It is a portfolio project, so code quality, clarity and
tests matter as much as features.

- Platforms: **iOS and Android only** (phones and tablets; adaptive layout).
- Bundle ID / applicationId: `io.github.fathul2703.jobtracker`. Display name: `Job Tracker`.
- Dart package name stays `job_application_tracker` (import prefix).
- UI language: **English**. Default currency: **IDR**.
- No backend. All data lives in a local SQLite database on the device.

## Technology stack

| Concern | Choice |
|---|---|
| Framework | Flutter 3.47 / Dart 3.13 |
| UI | Material 3 (`ColorScheme.fromSeed`), custom design tokens |
| State management / DI | `flutter_riverpod` 3.x — **no code generation** |
| Navigation | `go_router` (`StatefulShellRoute.indexedStack`) |
| Database | SQLite via `drift` + `drift_flutter` (native SQLite bundled by `sqlite3` build hooks) |
| Charts | `fl_chart` *(Phase 8)* |

Add a dependency only in the phase that needs it, and justify it.
Do **not** add: freezed, json_serializable, riverpod_generator, get_it, dio/http,
hive/isar, google_fonts, equatable, uuid.

## Architecture

```
UI (features/*)  ──ref.watch/read──▶  Providers & controllers
                                            │
                          ┌─────────────────┴────────────────┐
                          ▼                                  ▼
                   Repositories (data/)             Services (domain/services)
                          │                          pure Dart, no Flutter/DB
                          ▼
                   Drift database (data/database)
```

- Dependencies point downward only. `domain/` never imports `data/`, `features/` or Flutter widgets.
- **UI never talks to the database or repositories directly.** Reads go through
  providers; writes go through a controller (Notifier) that calls a repository.
- Repositories return **domain models** (`domain/models`), never Drift row classes.
- Services hold pure business logic (e.g. analytics). They take plain data and return plain data, so they are trivially unit-testable.
- No business logic inside `build()` methods.

## Folder structure

```
lib/
├── main.dart                 # bootstrap: ProviderScope + JobTrackerApp
├── app.dart                  # MaterialApp.router, themes, theme mode
├── core/
│   ├── router/               # app_router.dart (AppRoutes constants + GoRouter provider)
│   ├── theme/                # design_tokens, app_colors, status_colors, app_typography,
│   │                         # app_theme, theme_context (BuildContext extensions)
│   └── utils/                # clock, date_only, strings (pure Dart helpers)
├── data/
│   ├── database/             # app_database.dart, tables.dart, app_database.g.dart
│   ├── repositories/         # application, interview, checklist, note repositories
│   └── seed/                 # DemoDataSeeder (fictional demo data, debug only)
├── domain/
│   ├── errors.dart           # ValidationException, NotFoundException
│   ├── models/               # immutable domain models + drafts (create/update input)
│   ├── enums/                # ApplicationStatus, WorkMode, EmploymentType, ...
│   └── services/             # analytics_service, query/filter specs
├── providers/                # app-wide providers: data_providers (db, clock, repos), theme mode
├── features/                 # UI per feature: <feature>_screen.dart, widgets/, controllers
│   ├── shell/  dashboard/  applications/  interviews/  analytics/  settings/
└── shared/widgets/           # reusable widgets (EmptyState, SectionHeader, StatusChip, ...)

test/
├── helpers/                  # pump_app.dart, test_database.dart (in-memory db, FakeClock)
├── unit/                     # services, domain, providers, theme
├── data/                     # database + repository tests (in-memory Drift)
├── drift/                    # generated migration tests (from schema v2 onwards)
└── widget/                   # screen / flow tests

integration_test/             # on-device tests (real SQLite): run on simulator/emulator
drift_schemas/                # committed schema dumps, one JSON per schemaVersion
build.yaml                    # drift_dev options
```

Feature-specific providers/controllers live in that feature's folder.
App-wide providers live in `lib/providers/`.

## Coding conventions

- Follow `analysis_options.yaml`; `flutter analyze` must report **no issues**.
- Always run `dart format lib test` before committing.
- Imports inside `lib/`: package imports only (`package:job_application_tracker/...`).
- Files `snake_case.dart`, one public widget/class per file, ~300 lines max.
- Prefer `StatelessWidget`/`ConsumerWidget` + small private widgets over large build methods.
- Use `const` wherever possible. Dot shorthands and records are fine.
- Constants-holder classes are `abstract final class`.
- Navigate only with `AppRoutes.*` constants (`context.go`, `context.push`).
- No `print`; no ignored futures (`unawaited(...)` when intentional).
- Comments explain *why*, not *what*. No commented-out code.

## Database rules

Tables: `applications`, `status_history`, `interviews`, `checklist_items`, `notes`.
All child tables reference `applications.id` with `ON DELETE CASCADE`;
`checklist_items.interview_id` is an optional FK to `interviews`.

- Primary keys: `INTEGER` autoincrement.
- Enable `PRAGMA foreign_keys = ON` in `beforeOpen`.
- Store enums as **TEXT** via `textEnum<T>()` (the Dart name, e.g. `technicalTest`), never the index.
  Renaming an enum value requires a migration.
- DateTimes are stored as ISO-8601 text (`store_date_time_values_as_text`).
  Timestamps are written in **UTC** (`.toUtc()`); read values are UTC — call `toLocal()` only for display.
- Date-only fields (`applied_at`, `deadline_at`) are **UTC midnight of the calendar date**
  (`DateTime.toDateOnly()` in `core/utils/date_only.dart`). Never call `toLocal()` on them.
- Money: integers (`salary_min`, `salary_max`) + `salary_currency` (default `IDR`) + `salary_period`. Never `double`.
- A status change is **one transaction**: update `applications.status` + `updated_at`,
  insert a `status_history` row, and set `applied_at` the first time the status leaves `saved`.
- `created_at` / `updated_at` are set by repositories (with the injected `Clock`), not the UI.
- Drift row classes are suffixed `Row` (`ApplicationRow`); repositories map them to domain
  models and never expose them.
- Repository methods validate input and throw `ValidationException` / `NotFoundException`.
  Mutation methods are `async`, so errors always arrive through the returned `Future`.
- Text is trimmed; blank optional text is stored as `NULL`.
- SQL and Drift APIs are only used inside `lib/data/`.
- Any schema change: edit `tables.dart`, bump `schemaVersion`, run build_runner, then
  `dart run drift_dev make-migrations` (writes the schema dump, step-by-step helpers and
  migration tests), implement `onUpgrade`, and make the generated tests pass.
  Never edit a released migration.
- Generated `*.g.dart` files **are committed** so the project runs without build_runner.

### Metric definitions (analytics)

- **Submitted** = applications with `applied_at IS NOT NULL`.
- **Response rate** = submitted that reached Screening or later, **or** Rejected ÷ submitted.
  (Withdrawn is not a response.)
- **Interview rate** = submitted that ever reached Interview, Technical Test or Offer
  (per `status_history`) **or** have ≥ 1 interview ÷ submitted.
- **Offer rate** = submitted that ever reached Offer ÷ submitted.
- Pipeline order: Saved < Applied < Screening < Interview < Technical Test < Offer.
  Rejected and Withdrawn are terminal.

## State management rules

| Need | Provider |
|---|---|
| Database, repositories (DI) | `Provider` |
| Reactive reads (lists, detail by id) | `StreamProvider` / `StreamProvider.family` over `repo.watch…()` |
| UI state (search, filter, sort, theme mode) | `NotifierProvider` |
| Mutations (save, delete, change status) | `Notifier` / `AsyncNotifier` controller → repository |
| Derived data (analytics) | `Provider` that combines streams and calls a service |

- Prefer reactive streams over manual `ref.invalidate` after writes.
- `ref.watch` in `build`, `ref.read` in callbacks.
- Handle `AsyncValue` loading/error states explicitly in the UI.
- In tests, override providers (e.g. in-memory database) via `ProviderContainer.test(overrides: ...)` or `ProviderScope(overrides: ...)`.

## UI rules

- Material 3 only. Style Material widgets through component themes in `core/theme/app_theme.dart`, not per widget.
- **No hardcoded colors, spacing, radii or durations** in widgets. Use
  `context.colorScheme`, `context.textTheme`, `context.statusColors`,
  `AppSpacing`, `AppRadius`, `AppLayout`, `AppMotion`.
- Application status is shown with **color + icon/label**, never color alone.
- Every list/screen has empty, loading and error states (`EmptyState` widget).
- Adaptive layout: `NavigationBar` < 600dp, `NavigationRail` ≥ 600dp (extended ≥ 840dp).
  Page content is capped with `MaxWidthContent` (640dp).
- Both light and dark themes must look right; respect text scaling; touch targets ≥ 48dp.
- Design tone: clean, calm, professional. Avoid heavy gradients, glassmorphism and decorative animation. Use motion only to explain change.
- Small forms (note, checklist item, status change, filters) use bottom sheets; large forms use full-screen routes on the root navigator.

## Testing rules

- Every phase adds tests with the feature, not afterwards.
- `domain/services`: unit tests covering edge cases (empty data, zero denominators).
- Repositories: tests against an in-memory Drift database (`createTestDatabase()`),
  with `FakeClock` for timestamps.
- Test stream behaviour with one long-lived subscription; don't assume the initial
  query emits before a write.
- `integration_test/` covers what only a device can prove (native SQLite, file database).
  It must only touch records it creates.
- Screens: widget tests for the main flows, using `test/helpers/pump_app.dart`.
- Tests must not depend on the real clock; inject time where needed.
- `flutter analyze` and `flutter test` must pass before any commit.

## Important commands

```bash
flutter pub get
dart format lib test
flutter analyze
flutter test
dart run build_runner build                 # after changing Drift tables
dart run drift_dev make-migrations          # after bumping schemaVersion
flutter test integration_test -d <device>   # on-device database smoke test
flutter run                                 # pick an iOS simulator or Android emulator
flutter build apk --debug
flutter build ios --simulator --debug
```

## Workflow

- The work is split into phases. **Do not start the next phase without the owner's approval.**
- Branch per phase from `main`: `phase-<n>-<name>` (e.g. `phase-3-data-layer`).
- Each phase ends with: format → analyze → test → Android/iOS build check → commit.

| Phase | Scope | Status |
|---|---|---|
| 1 | Audit & planning | ✅ |
| 2 | Foundation: cleanup, IDs, lints, Riverpod, GoRouter, theme/tokens, shell, tests | ✅ |
| 3 | Data layer: Drift, tables, migrations, models, repositories, seed data | ✅ |
| 4 | Applications CRUD + status change | ⏳ |
| 5 | Search, filter, sort | |
| 6 | Interviews, checklist, notes, status timeline | |
| 7 | Dashboard | |
| 8 | Analytics | |
| 9 | Settings: persisted theme, backup/export/import, clear data | |
| 10 | Polish: states, a11y, bundled font, icon & splash, README | |
