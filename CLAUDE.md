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
| Formatting | `intl` (dates, numbers, currency symbols) |
| Links | `url_launcher` (job postings, meeting links) |
| Preferences | `shared_preferences` (theme mode) |
| Files | `share_plus`, `file_picker`, `path_provider` (backup export/restore, CSV) |
| Charts | `fl_chart` (monthly column chart); simple bars are plain widgets |

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
│   └── utils/                # clock, date_only, strings, formatters
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
- Search, filter and sort run in SQL (`ApplicationRepository.watchAll(query:)` with
  `ApplicationQuery` from `lib/domain/models/application_query.dart`). Escape user input
  used in `LIKE` so `%` and `_` match literally. Always end `ORDER BY` with stable
  tie-breakers (`updated_at DESC, id DESC`).
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
| Reactive reads (lists, detail by id) | `StreamProvider` / `StreamProvider.autoDispose.family` over `repo.watch…()` (`lib/providers/application_providers.dart`) |
| UI state (search, filter, sort, theme mode) | `NotifierProvider` |
| Mutations (save, delete, change status) | `AsyncNotifier` controller → repository (e.g. `features/applications/application_controllers.dart`). State = last action's loading/error; methods return success so screens can navigate. Guard with `ref.mounted` after awaits. |
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
  Page content is capped with `MaxWidthContent` (640dp). Screens use `ContentAppBar`
  (not `AppBar`) so the title, back button and actions line up with that column on
  tablets; on phones it looks like a plain AppBar.
- Both light and dark themes must look right; respect text scaling; touch targets ≥ 48dp.
- Design tone: clean, calm, professional. Avoid heavy gradients, glassmorphism and decorative animation. Use motion only to explain change.
- Small forms (note, checklist item, status change, filters) use bottom sheets; large forms use full-screen routes on the root navigator.
- Full-screen forms: close (X) on the left, filled **Save** on the right; guard unsaved changes
  with `PopScope` + "Discard changes?" dialog. Field validators come from the domain draft
  (e.g. `ApplicationDraft.validateCompany`) so UI and repository share rules.
- Show repository errors with `errorMessage()` (`lib/shared/error_message.dart`) in a SnackBar.
- Color scheme: tonalSpot for surfaces/containers, primary roles from the fidelity variant
  (crisp indigo accent). Don't use saturated containers for large areas.
- Routes: `/applications`, `/applications/new`, `/applications/:id`, `/applications/:id/edit`
  (use `AppRoutes.*` helpers).
- Modal bottom sheets use `useRootNavigator: true` so they cover the navigation bar.
- Application detail = compact header + fixed 4-tab `TabBar` (Overview, Interviews,
  Checklist, Notes) — tabs must all fit on a 360dp phone; counts are overlaid `Badge`s.
  Tab widgets live in `features/applications/detail/`; interview form/cards in
  `features/interviews/`.
- Open external links only through `openLink()` (`lib/shared/open_link.dart`, url_launcher);
  it validates http(s) and reports failures in a SnackBar.
- Dashboard (`features/dashboard/`) is about "what's next": numbers come from the pure
  `DashboardSummary` (`domain/services/dashboard_summary.dart`); cross-application lists use
  joined queries (`InterviewRepository.watchUpcoming`, `ApplicationRepository.watchRecentActivity`)
  returning `UpcomingInterview` / `RecentStatusChange`. Rates belong to Analytics, not here.
- Charts follow the dataviz skill: pick the form first, one axis, thin marks (≤ 24px, 4px
  rounded data end, square baseline), 2px surface gap between stacked segments, hairline
  grid, legend for ≥ 2 series, tooltip on touch, a table view, and a `Semantics` label that
  reads the numbers. Test rendered size, not just labels.
- **Run the palette validator before shipping chart colors** (dataviz skill:
  `scripts/validate_palette.js`, `--ordinal` for steps of one hue). Chart-only tokens live
  in `ChartColors` (`core/theme/chart_colors.dart`).
- The status palette is for text-on-tint chips (always with icon + label). It fails
  categorical chart checks, so never use it as the only identity of chart marks — use
  `StatusBreakdown` (labelled rows, single-hue bars) instead of a multi-color stacked bar.
- Analytics numbers come from the pure `Analytics.build` (`domain/services/analytics.dart`)
  implementing the metric definitions below; show every rate with its raw count
  ("73% · 8 of 11").
- Settings (`features/settings/`): theme is persisted through `SettingsStore`
  (`data/settings/`, shared_preferences opened in `main` before `runApp`). Backups use
  `BackupService` (`data/backup/`): explicit versioned JSON (`format`, `version`), date-only
  as `yyyy-MM-dd`, timestamps as UTC ISO-8601, ids preserved; restore **replaces all data**
  in one transaction and throws `BackupFormatException` without changing anything on bad
  input. Bump `BackupService.version` and keep reading older versions if the format changes.
- File sharing/picking goes through `FileExchange` (`data/files/`); tests use
  `FakeFileExchange`. Pass the tapped widget's rect as `origin` (required on iPad).
- Irreversible bulk actions need two steps: a confirm dialog, then
  `showTypeToConfirmDialog` (type DELETE).
- `AppInfo` (`core/app_info.dart`) must match `version:` in pubspec.yaml (a test checks it).
- Font: bundled Inter variable font (`assets/fonts`); `FontWeight` drives its `wght`
  axis. Tracking in `AppTypography` is tuned for Inter.
- Branding is generated from code: `flutter test tool/icon/render_icon_test.dart`, then
  `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`. After
  running them, check `git diff` on `ios/Runner/Info.plist` and `project.pbxproj` —
  flutter_launcher_icons has written an invalid `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS`
  value before; revert unrelated changes.
- Every `FloatingActionButton` sets `heroTag: null` (tabs stay mounted in an
  `IndexedStack`; the default shared hero tag throws when pushing a route).
- `test/widget/accessibility_test.dart` audits tap targets, labels, contrast and 200%
  text on every main screen — add new screens to it.
- Reuse `showTextInputSheet` for single-field edits and `showConfirmDialog` before
  destructive actions (except removing a checklist item, which is low-stakes).
- When a provider re-runs (e.g. a new search), keep showing the previous data: match on
  `AsyncValue(value: final x?)` instead of `AsyncData` to avoid flashing a spinner.

## Testing rules

- Every phase adds tests with the feature, not afterwards.
- `domain/services`: unit tests covering edge cases (empty data, zero denominators).
- Repositories: tests against an in-memory Drift database (`createTestDatabase()`),
  with `FakeClock` for timestamps.
- Test stream behaviour with one long-lived subscription; don't assume the initial
  query emits before a write.
- In widget tests (`testWidgets`), never await a Drift **stream** (`watch…().first`): its
  timers don't run in the fake async zone and the test hangs. Use plain queries
  (`db.select(...).get()`) for assertions. `ListView` children are built lazily, so
  `scrollUntilVisible` before finding off-screen widgets.
- Don't await platform side effects (haptics, etc.) before updating UI; use `unawaited`.
- After `enterText`, `pump()` before tapping a button whose enabled state depends on the
  text (e.g. Save in `showTextInputSheet`).
- `DateFormat.jm()` puts a narrow no-break space (U+202F) before AM/PM; match times with
  `\s` in a RegExp, not a plain space.
- `pumpApp` unmounts the app and closes the database in real async on tear-down, so a
  failing widget test reports its failure instead of hanging. Keep it that way.
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
dart format --output=none --set-exit-if-changed lib test tool   # what CI checks
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
| 4 | Applications CRUD + status change | ✅ |
| 5 | Search, filter, sort | ✅ |
| 6 | Interviews, checklist, notes (status timeline done in Phase 4) | ✅ |
| 7 | Dashboard | ✅ |
| 8 | Analytics | ✅ |
| 9 | Settings: persisted theme, backup/export/import, clear data | ✅ |
| 10 | Polish: states, a11y, bundled font, icon & splash, README | ✅ |
