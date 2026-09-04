# Habitly — Technical Architecture

> Companion to `docs/SRS.md`. This file maps the BRD's suggested `lib/` tree
> (`docs/Habitly_AGENT.md` §"Recommended project structure") onto the tree this repo
> actually enforces (root `CLAUDE.md`), and records the concrete package/module
> decisions. Read `CLAUDE.md` first — its layer-boundary and DI rules are
> non-negotiable and apply to every Habitly feature below.

## 1. Structure mapping

The BRD's flat suggestion and this repo's feature-first Clean Architecture describe
the same responsibilities; only the folder shape differs. Habitly code lands here:

| BRD suggestion | This repo | Notes |
| --- | --- | --- |
| `app/app.dart`, `router.dart`, `theme/` | `lib/app/views/app.dart`, `lib/res/routes/`, `lib/core/presentation/theme/` | Already scaffolded; reused as-is |
| `core/database/` | `lib/core/data/database/` (Drift) | New — see §2 |
| `core/notifications/` | `lib/services/notifications/` | New — mirrors existing `lib/services/push_notification/` sibling pattern |
| `core/backup/` | `lib/core/data/backup/` | New |
| `core/utils/`, `core/widgets/` | `lib/core/presentation/utils/`, `lib/core/presentation/widgets/` | Already scaffolded; reused |
| `features/onboarding/` | `lib/features/onboarding/` | New feature (generated via `generate_feature.dart`) |
| `features/today/` | `lib/features/today/` | New |
| `features/habits/` | `lib/features/habits/` | New — create/edit/detail/archive |
| `features/calendar/` | `lib/features/calendar/` | New |
| `features/insights/` | `lib/features/insights/` | New |
| `features/search/` | folded into `features/habits/presentation/search/` | Small enough not to warrant its own feature module |
| `features/settings/` | `lib/features/settings/` | New |
| `domain/models`, `domain/services`, `domain/repositories` | split per-feature: `features/xxx/domain/entity`, `.../domain/repo`, `.../domain/usecase`, plus shared pure logic in `core/domain/habit/` | See §3 — recurrence/streak engine is the one piece genuinely shared across features |
| `test/unit`, `test/widget`, `test/integration` | unchanged — `test/` at repo root | |

`lib/features/sample_feature/` (login/reset-PIN) is **out of scope for Habitly** —
the BRD explicitly forbids accounts/login (§4.2). It is left in place rather than
deleted, since deleting is a destructive, hard-to-reverse action on code this agent
didn't author; `app_pages.dart`/`app_routes.dart` are repointed so Habitly's own
routes are what actually loads at runtime (see §5). Confirm with the user before
removing `sample_feature/` outright.

## 2. Persistence — Drift

New dependencies (added to `pubspec.yaml`): `drift`, `sqlite3_flutter_libs`, `path`
(runtime); `drift_dev`, `build_runner` (dev). Rationale: BRD §11.2 explicitly
recommends Drift for relational occurrence/history queries and versioned migrations;
`sqlite3_flutter_libs` covers Android/iOS/Windows/macOS/Linux so `flutter run` keeps
working on this Windows dev machine too.

Location: `lib/core/data/database/app_database.dart` (Drift `@DriftDatabase` class),
tables in `lib/core/data/database/tables/`, generated code
`app_database.g.dart` via `dart run build_runner build`.

Full column-level schema: `docs/DATA_MODEL.md`.

Migration policy: every schema change ships a `MigrationStrategy.onUpgrade` step;
`onCreate`/`onUpgrade` failures surface to `S01` (splash) as a recoverable error —
**never** call `deleteDatabase` automatically (BRD non-negotiable rule, SRS FR-02).

## 3. Domain layer — recurrence & streak engine

Per `CLAUDE.md`: `core/domain/` must be pure Dart, no Flutter, no GetX. The
recurrence engine and streak/adherence calculator are the one piece of logic shared
by `today`, `habits`, `calendar`, and `insights`, so they live in
`lib/core/domain/habit/`:

- `recurrence_engine.dart` — `List<DateTime> occurrencesBetween(HabitScheduleRule, DateRange)`.
  Pure function, bounded window (never materializes years of rows — BRD §12.1).
- `streak_calculator.dart` — consumes occurrences + resolved `CheckIn`s, returns
  current/best streak deterministically (BRD §8.3).
- `adherence_calculator.dart` — successful/eligible ratio (BRD §10).

These have no repository/DB dependency — they take plain value objects in and
return plain value objects out, which is what makes FR-30/FR-31 ("unit-testable in
isolation") achievable. Each feature's `domain/usecase/` composes these with its own
repository.

Per-feature domain entities (`features/habits/domain/entity/habit.dart`, etc.) stay
pure Dart per `CLAUDE.md`'s `features/xxx/domain/` rule — no `fromJson`/`toJson`
there; that belongs to `data/model/` DTOs that wrap the Drift row types.

## 4. State management

GetX, per repo convention — no new package. Conventions to follow (already
established, do not deviate):

- `Get.find<T>()` only inside controllers/widgets; DI wiring happens in each
  feature's `Bindings`, registered with `Get.lazyPut(..., fenix: true)`.
- Async flows go through `BaseController.doAction<T>()` (dartz `Either<Failure, T>`
  from usecases) — this is what gives Habitly testable, predictable state without
  adopting Riverpod/Bloc, satisfying BRD §12.
- Initial data fetch in `onInit()`, never in a constructor.
- `RxList.assignAll()` for list updates (never reassign `.value`).

## 5. Navigation

`go_router` is **not** introduced — the existing `GetPage`/`AppPages` routing stays,
since it already satisfies "typed/declarative route handling" well enough and
swapping it is unrelated churn. `AppRoutes`/`AppPages` gain Habitly's routes
(`onboarding`, `today` via `AppShell`, `createHabit/*`, `habitDetail`, `editHabit`,
`dayDetail`, `search`, `archived`, `settings/*`, `backupRestore`). `AppPages.initial`
moves from `AppRoutes.login` to a new `AppRoutes.splash`, which decides
onboarding-vs-shell per FR-01.

`AppShell` (`lib/app/shell/`) already provides the 4-tab `BottomNavigationBar` +
`IndexedStack`-style body switch the BRD's IA (§6) calls for (Today / Calendar /
Insights / Settings); its placeholder tabs are replaced with the real feature
screens. The central "+" create action is a `FloatingActionButton` on `AppShell`
pushing the create-habit route, not a fifth tab.

## 6. What is *not* touched

The existing `dio`/`ApiClient`/`firebase_core`/`firebase_messaging`/`geolocator`/
`local_auth`/`mobile_scanner`/`image_cropper` plumbing in this boilerplate is
unrelated to Habitly and is left alone rather than ripped out — removing working
(if unused) code is a separate cleanup decision for the user to make, not an
implicit side effect of building Habitly. Habitly's own features simply never import
any of it, consistent with BRD §11 ("no network data source in MVP").

## 7. Notifications

`lib/services/notifications/habit_notification_service.dart` wraps
`flutter_local_notifications` + `timezone`. Notification id = stable hash of
`(habitId, reminderId)` (FR-50). Reconciliation entry point:
`reconcileSchedules()`, called from splash bootstrap (FR-01) and after any
habit/reminder/settings mutation that affects scheduling (FR-51). Quiet-hours
suppression (SRS §9.6) is evaluated at fire-time construction, not by mutating the
`Reminder` row.

## 8. Backup / export

`lib/core/data/backup/` — `backup_service.dart` serializes the full local dataset
(via Drift queries, not raw file copy, so the checksum covers structured data) to a
versioned JSON envelope (`BackupMeta` + tables). `restore_service.dart` validates
schema version + checksum, snapshots the current DB, then replaces data inside a
single transaction with rollback on any failure (FR-60/FR-61). CSV export is a
separate, simpler flattening pass over `CheckIn` joined with `Habit` (FR-62).

## 9. Build/implementation order

Follows BRD §20 phases, adapted to this repo. Status as of the last build pass
(`flutter analyze` clean, unit tests green):

- **Phase 0 — done**: dependencies, Drift schema + migrations, recurrence/streak/
  adherence/week-quota/calendar-aggregation engine + unit tests, theme/nav wiring,
  docs (this file, `SRS.md`, `DATA_MODEL.md`).
- **Phase 1 — mostly done**: Today (empty + dashboard, check-in/undo/skip, quick-entry
  sheet), Create Habit (Basics/Schedule/Goal/Review stepper), archive/delete wired
  from Habit Detail. **Not done**: onboarding (S02/S03 — app currently boots
  straight to the shell), Edit Habit (S13 — menu item shows a "coming soon"
  snackbar).
- **Phase 2 — not started**: reminders (S10), permission flow, notification
  scheduling/reconciliation. Create Habit has no reminders step yet.
- **Phase 3 — mostly done**: Habit Detail (S12, with a 90-day heatmap), Calendar
  month view (S14) aggregating all active habits (no per-habit filter yet), Day
  Detail (S15, historical check-in edit/undo/skip), Insights overview (S16, ranking
  + most-consistent + 7/30/90d range). **Not done**: a dedicated per-habit Insights
  screen (S17) beyond what Habit Detail already shows; weekday-performance/monthly
  trend charts.
- **Phase 4 — not started**: backup/restore/export, delete-all-data.
- **Phase 5 — not started**: accessibility pass, edge-case hardening (timezone/DST/
  clock-change reconciliation beyond what `GetHabitOccurrencesUseCase`'s real-clock
  "today" already gives), release QA per BRD §19.

Search/filter/archive-management (S18/S19) and Settings sub-screens (S21-S24)
beyond the single consolidated Settings tab are also outstanding.

Each phase should leave `flutter analyze` clean and add unit tests for any new pure
logic before moving to the next phase.
