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
- **Phase 1 — done**: Today (empty + dashboard, check-in/undo/skip, quick-entry
  sheet), Create Habit (Basics/Schedule/Goal/Reminders/Review stepper),
  archive/delete wired from Habit Detail, onboarding (S01–S03, see addendum
  below), Edit Habit (S13, see addendum below).
- **Phase 1 addendum — Onboarding (S01–S03) done**: `AppRoutes.splash` is now
  `AppPages.initial` (was `appShell`). `SplashController` calls
  `AppDatabase.ensureReady()` (a real `SELECT 1`) so a DB init failure
  surfaces as a recoverable Retry screen at splash, never silently resets
  the DB (FR-02). First-launch detection is a persisted
  `AppSettingsRepository.isOnboardingComplete()` flag, set only when the
  user finishes S03's Continue — force-quitting mid-onboarding re-shows it
  next launch, which is correct. Start-of-week and time-format prefs
  (new `AppSettingsRepository` methods, new `AppTimeFormat` enum) are set
  here and editable again later from Settings. Start-of-week feeds the
  Calendar month grid's first column (`CalendarController`); time-format
  feeds `TimeFormatController.formatTime` (registered alongside
  `ThemeController`/`LocaleController` as a permanent singleton in
  `app_flavour.dart`'s `_initialize()` — see §11 addendum below for why this
  moved out of `app.dart`), used wherever a stored 'HH:mm' reminder/quiet-hours
  time is displayed.
  Known gap: an already-mounted Calendar tab doesn't live-refresh if
  start-of-week changes in Settings mid-session (picks it up on next
  load/launch) — documented in `SettingsController`, not silently broken.
- **Phase 2 — done**: reminders (S10) in Create Habit, permission flow
  (in-context request + non-blocking denial per FR-53), notification
  scheduling/reconciliation (`HabitNotificationService` +
  `ReminderReconciler`), quiet hours + master toggle in Settings (S22).
  Scheduling is one-shot-next-occurrence + reconcile-on-open/mutation
  (see file header of `core/domain/habit/reminder_scheduler.dart` for why —
  not native daily/weekly OS repeat). Not done: no notification-tap deep
  link into the habit (BRD §9).
- **Phase 1 addendum — Edit Habit (S13) done**: `HabitFormController` (shared
  by Create and Edit) + `HabitEntity.copyWith`'s `clearX` flags. Editing only
  appends a new `HabitSchedule` row when the recurrence *pattern* actually
  changed (`HabitScheduleRule.hasSameShapeAs`) — an unrelated edit (name,
  color, goal) never resets an `interval` habit's phase. Reminders are
  fully replaced on every save (not historical data, no versioning needed).
  Archive/Delete deliberately stay on Habit Detail's menu, not duplicated
  on the Edit screen (BRD §S13 "destructive actions separated").
- **Phase 3 — mostly done**: Habit Detail (S12, with a 90-day heatmap), Calendar
  month view (S14) aggregating all active habits (no per-habit filter yet), Day
  Detail (S15, historical check-in edit/undo/skip), Insights overview (S16, ranking
  + most-consistent + 7/30/90d range). **Not done**: a dedicated per-habit Insights
  screen (S17) beyond what Habit Detail already shows; weekday-performance/monthly
  trend charts.
- **Phase 4 — done**: `lib/services/backup/` — `BackupBundle` (spans multiple
  features' entities, so lives in `services/` not `core/domain`, same reasoning
  as `ReminderReconciler`) + `BackupCodec` (pure JSON encode/decode/checksum,
  unit-tested for round-trip equality and tamper detection — BRD §19.1) +
  `BackupService` (build/export/share, never mutates on create) +
  `RestoreService` (validate → user-confirmed summary → best-effort pre-restore
  safety snapshot → `HabitRepository.replaceAllData` in one transaction) +
  `CsvExportService`. New repository methods `deleteAllData`/`replaceAllData`.
  Surfaced from Settings' Data & Backup section: Create/Restore/Export CSV/
  Delete All (typed "DELETE" confirmation, BRD §S26). Restore and delete-all
  both route back through Splash afterward (`Get.offAllNamed(AppRoutes.splash)`)
  so Today/Calendar/Insights controllers rebuild fresh instead of showing
  stale cached lists — they're kept alive in the shell's `IndexedStack` and
  won't otherwise notice the dataset changed under them.
- **Phase 5 — not started**: accessibility pass, edge-case hardening (timezone/DST/
  clock-change reconciliation beyond what `GetHabitOccurrencesUseCase`'s real-clock
  "today" already gives), release QA per BRD §19.

Search/filter/archive-management (S18/S19) and Settings sub-screens (S21-S24)
beyond the single consolidated Settings tab are also outstanding.

Each phase should leave `flutter analyze` clean and add unit tests for any new pure
logic before moving to the next phase.

## 10. Real-device verification (Android emulator)

Static analysis and 105 unit tests were passing before the app was ever actually
launched. Running it end-to-end on a real Android emulator (onboarding → create
habit with reminders → check in → Habit Detail → Settings) surfaced four real bugs
none of the above caught:

1. **`AppDatabase` constructed twice** — `app_flavour.dart` used
   `Get.lazyPut(..., fenix: true)` for app-lifetime singletons (database,
   repository, notification services). GetX's default smart management disposes
   `lazyPut` registrations once no route references them, and `fenix` just means
   "recreate lazily next time" — so once onboarding's routes were cleared via
   `Get.offAllNamed`, the next `Get.find<AppDatabase>()` built a **second** Drift
   instance with its own SQLite connection to the same file. Drift's own runtime
   warning caught it. Fixed: `Get.put(..., permanent: true)` for every app-lifetime
   singleton in `_initialize()` — `lazyPut`/`fenix` stays correct for per-screen
   controllers (Today/Calendar/.../Create/Edit), which *should* be disposed.
2. **Today never reloaded after creating a habit** — `Get.toNamed(AppRoutes.createHabit)`
   (both the empty-state CTA and the FAB) wasn't awaited, so `CreateHabitController`'s
   `Get.back(result: true)` had nowhere to land; Today kept showing "No habits yet"
   after a successful create. Same gap existed on Insights → Habit Detail. Fixed
   both call sites to `await` and reload on `true`. Habit Detail itself only
   returned a result on archive/delete, not on a plain back-navigation after an
   edit — added a `PopScope` (mirroring `DayDetailScreen`'s existing pattern) so
   Today/Insights also refresh after an edit, not just archive/delete.
3. **App still labeled "Onkur Customer"** in the launcher/task-switcher/system
   permission dialogs — leftover boilerplate branding never updated. Fixed in
   `AndroidManifest.xml`, iOS `Info.plist`, `linux/CMakeLists.txt`, and
   `TextEnum.appName` (which feeds `GetMaterialApp.title`, i.e. the Android
   recent-apps label — a second, separate place from the manifest's
   `android:label`).
4. **Settings' Time format `SegmentedButton` overflowed the screen by 24px** — it
   was the trailing child of a `Row` fighting a `Spacer()` for space against a
   label; the 3-segment button (System/12h/24h) didn't fit what was left. Fixed
   by stacking label-above/control-below in a `Column`, matching the pattern
   already used (without this bug) in Onboarding Preferences and the Start-of-week
   row right below it.

Takeaway worth remembering: none of these were things `flutter analyze` or unit
tests could have caught — they're integration/runtime/layout concerns that only
show up by actually running the app. Do this pass again before any release, not
just once.

## 11. Visual redesign + post-redesign audit fixes

The app was restyled from the original navy/yellow Material boilerplate to a
warm sage/clay palette (matching a Claude Design mockup pass), with Newsreader
serif for display/headline text and Manrope sans elsewhere. Single source of
truth stays `lib/core/presentation/theme/color_schemes.dart` (`AppColors`) +
`text_theme.dart` — every screen consumes it via `ColorScheme`/`context.`
extensions, nothing hardcodes hex outside that file (verified by grep as part
of the audit below; the one hit, an onboarding `Colors.green`, is fixed).
`Today`, `Habit Detail`, `Calendar`, and `Insights` also picked up
`flutter_animate` micro-interactions (progress-ring fill, animated
check/undo swap, staggered card entrance, count-up stat numbers) and a
`neutralMiss` token so a missed/skipped day never renders red anywhere
(BRD's "never shame a skipped day" intent) — `OccurrenceHeatmap` and the
Calendar day grid both use it instead of `colorScheme.error`.

A follow-up self-audit against this file's own CLAUDE.md rules and basic
accessibility/contrast checks found and fixed four issues, none caught by
`flutter analyze` or the test suite:

1. **`Get.put(Controller())` inside `_MyAppState`** (`app.dart`) — a direct
   violation of the "never `Get.put` inside a widget State class" rule.
   `ThemeController`/`LocaleController`/`TimeFormatController` moved to
   `app_flavour.dart`'s `_initialize()` as `Get.put(..., permanent: true)`
   singletons, same as every other app-lifetime dependency; `app.dart` now
   only `Get.find()`s them.
2. **`TodayHabitCard`'s status control lost its accessibility label** in the
   redesign — the original `IconButton` had an implicit tooltip/semantics,
   the replacement animated custom widget didn't. Fixed with an explicit
   `Semantics`/`Tooltip` pair carrying a per-state label ("Done. Tap to
   undo", "Mark done", "Missed", …).
3. **Primary sage `#4C8F6B` on white text ≈ 3.85:1 contrast** — under WCAG
   AA's 4.5:1 for normal text, and this color carries white text/icons on
   the FAB, filled buttons, and the Insights hero card. Darkened to
   `#3E7A5A` (≈5.1:1), same hue.
4. **`lib/services/utilities/secure_storage_service.dart` was dead code** —
   zero callers anywhere in `lib/`, a leftover from the boilerplate's
   account/login flow that Habitly's BRD explicitly rules out (no accounts).
   Deleted rather than force a use; `flutter_secure_storage` itself stays a
   dependency (`core/data/cache/preference/shared_preference.dart` uses it).

Also added: a dedicated `SaveCheckInUseCase` test
(`test/unit/features/habits/save_check_in_use_case_test.dart`) — the app's
single most-executed write path had no direct unit test before, only
coverage via downstream stats/reconciler tests.

Still genuinely outstanding from that audit, not attempted here: no CI
pipeline, no cert pinning on `ApiClient`, no crash reporting, no widget
tests (only unit tests exist across the whole suite) — all pre-existing gaps
already tracked in this file's "Known TODOs" equivalent in the root
`CLAUDE.md`.
