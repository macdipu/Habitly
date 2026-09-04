# Habitly — Software Requirements Specification (SRS)

> Derived from `docs/Habitly_AGENT.md` (source BRD). This SRS translates that product
> contract into implementation-grade requirements against the *actual* codebase
> (this repo — a GetX Clean Architecture Flutter boilerplate, package name `customer`,
> project directory `habbit_tracker`). Where the BRD leaves a decision open, section 9
> locks it. Treat this file, `docs/ARCHITECTURE.md`, and `docs/DATA_MODEL.md` as the
> living technical contract; `docs/Habitly_AGENT.md` remains the source of product truth.

## 1. Purpose

Build **Habitly**: a fully offline, privacy-first habit tracker for Android and iOS,
implemented in Flutter on top of this repository's existing GetX + Clean Architecture
scaffold (see root `CLAUDE.md`). No accounts, no backend, no cloud sync, no telemetry.

## 2. Scope

In scope (MVP, BRD §4.1):
- Onboarding + local preferences (theme, start-of-week, time format)
- Habit CRUD: create, edit, archive, restore, delete
- Schedule types: daily, specific weekdays, X-times/week, interval(N days)
- Habit types: binary, count, duration, avoid/quit
- Today dashboard, check-in (incl. undo/skip/notes), historical day edits
- Streaks, adherence %, calendar heatmap, insights/trends
- Local notifications with reconciliation on edit/archive/delete/timezone change
- Search/filter/archive management
- Local JSON backup/restore + CSV/JSON export
- Accessibility, dark/light/system theme, localization-ready strings

Out of scope (BRD §4.2): accounts, cloud sync, social features, web dashboard,
shared habits, payments, wearables, online AI, server push.

## 3. Definitions

| Term | Meaning |
| --- | --- |
| Occurrence | One scheduled instance of a habit on a specific local date, derived at query time from `HabitSchedule`, never pre-materialized for the far future |
| Check-in | A user record (`CheckIn`) resolving one occurrence: value + status + optional note |
| Effective date | The date from which an edited schedule/goal applies; occurrences before it use the prior definition |
| Local date | Calendar date in the device's current timezone, stored independent of UTC rollover |

## 4. Functional Requirements

Numbered `FR-xx`, each traceable to a BRD section and to a screen ID (`S01`–`S26`,
BRD §7).

### 4.1 Onboarding (S01–S04)
- **FR-01** App boots, runs pending DB migrations, loads settings, and routes to
  Onboarding (first launch) or Today — never blocks on network (BRD §S01).
- **FR-02** DB init failure shows a recoverable error screen (Retry / Restore Backup);
  the DB is never silently deleted (BRD §S01, §17).
- **FR-03** Onboarding collects start-of-week, time format, theme, and a notification
  permission explainer; every field has a default and Continue is always available
  (BRD §S03).

### 4.2 Habit CRUD (S07–S13, S19)
- **FR-10** Create Habit is a multi-step flow: Basics → Schedule → Goal → Reminders →
  Review, with an in-memory/local draft preserved if the user backgrounds the app
  mid-flow (BRD §S07–S11).
- **FR-11** Schedule step must reject a zero-day selection and must render a live
  preview sentence (e.g. "Mon, Wed, Fri starting Sep 2") before Next is enabled.
- **FR-12** Habit creation is atomic: the habit record persists even if notification
  scheduling fails; the user is informed reminders need attention (BRD §S11).
- **FR-13** Editing a habit never rewrites existing `CheckIn` rows. Schedule/goal
  changes apply from an `effectiveFrom` date forward only (BRD §S13, Core Rule
  "Immutable history").
- **FR-14** Archiving cancels future reminders and removes the habit from Today's due
  list, but preserves full history and remains visible in Archived Habits with Restore
  and Delete actions (BRD §S19).
- **FR-15** Deleting a habit requires an explicit confirmation dialog per BRD §S26; an
  "export first" affordance is offered.

### 4.3 Today / check-in (S04–S06)
- **FR-20** Today groups habits into Due now / Later today / Completed, each with a
  single-tap status control for binary habits and a quick-entry sheet (S06) for
  count/duration habits.
- **FR-21** A completed check-in can be undone from the same control without a
  confirmation dialog (non-destructive, immediately reversible).
- **FR-22** Empty state (no habits yet) offers a dominant "Create your first habit"
  CTA plus optional presets (Drink water, Read, Exercise, Sleep on time) that
  pre-fill the Create flow (BRD §S04).

### 4.4 Recurrence & streak engine (BRD §8)
- **FR-30** Occurrence generation is a pure function of `(HabitSchedule, dateRange)`
  with no I/O and no Flutter/GetX dependency — unit-testable in isolation
  (`core/domain` per `CLAUDE.md` layering; see `docs/ARCHITECTURE.md` §3).
- **FR-31** Streak = consecutive scheduled occurrences meeting the success rule,
  counted backward from the most recent *resolved* occurrence. Non-scheduled days
  are ignored. A pending occurrence later today never breaks the streak. Skipped
  occurrences neither increment nor break the streak (BRD §8.3).
- **FR-32** Success rule by type: Binary = completed once; Count = value ≥ target;
  Duration = minutes ≥ target; Avoid = no logged slip, or value ≤ threshold
  (BRD §8.1).
- **FR-33** Weekly-quota schedules: one occurrence per calendar day counts toward the
  quota; multiple same-day check-ins do not multiply progress unless the habit type
  is Count (BRD §21.1, locked in §9 below).
- **FR-34** Adherence % = successful eligible occurrences ÷ eligible scheduled
  occurrences × 100; skipped occurrences are excluded from both numerator and
  denominator.

### 4.5 Calendar & insights (S14–S17)
- **FR-40** Calendar month view colors only scheduled days by status
  (success/partial/missed/skipped); unscheduled days never render as failures
  (BRD §S14).
- **FR-41** Day Detail supports adding/editing/removing a historical check-in;
  streak/adherence recompute immediately and deterministically on save (BRD §S15).
- **FR-42** Insights screens show "Not enough data" instead of a misleading average
  when a habit has zero eligible scheduled occurrences in range (BRD §S17).

### 4.6 Notifications (BRD §9)
- **FR-50** Each `Reminder` maps to a stable notification id derived from
  `(habitId, reminderId)` so it can be individually cancelled/rescheduled.
- **FR-51** Habit edit/archive/delete cancels affected pending notifications before
  any rescheduling.
- **FR-52** Scheduling is timezone-aware (`timezone` package); on a detected
  timezone change, future reminders reschedule to the same local intended time
  without altering historical local dates.
- **FR-53** Notification permission denial never blocks habit save; a non-blocking
  banner with "Open Settings" is shown instead (BRD §17).
- **FR-54** Exact-alarm permission is not requested; standard OS-scheduled
  notifications are acceptable (BRD §9).

### 4.7 Backup / export / restore (S23–S24)
- **FR-60** Backup export is a versioned JSON bundle (`BackupMeta` + habits +
  schedules + reminders + check-ins + settings) with a schema version and checksum;
  creating a backup never mutates live data.
- **FR-61** Restore validates file format/schema and checksum before writing;
  invalid/corrupt files are rejected wholesale (no partial restore). An automatic
  safety snapshot of the current DB is taken immediately before a destructive
  restore.
- **FR-62** CSV export produces a flattened, human-readable check-in history file
  with unambiguous ISO-8601 dates and explicit units.
- **FR-63** "Delete all data" requires typed confirmation (BRD §S26) and clears the
  local database and all scheduled notifications.

### 4.8 Settings (S20–S22, S25)
- **FR-70** Appearance, notification, and privacy settings persist immediately via
  the existing `AppSettingsRepository`/`SharedPreference` pattern and apply without
  restart.
- **FR-71** Quiet hours: locked to *suppress* behavior for MVP — a reminder that
  would fire inside quiet hours is not delivered and is not silently rescheduled to
  fire outside the window unless the user has explicitly enabled "show next valid
  reminder" (see §9.6).

## 5. Non-Functional Requirements

Mapped from BRD §15, restated as acceptance-testable statements:

| ID | Requirement | Verification |
| --- | --- | --- |
| NFR-01 | Zero valid data loss after a successful write, across restart/force-close | Integration test: write → kill process → relaunch → assert row present |
| NFR-02 | 100% of core flows (create/check-in/history/backup) work in airplane mode | Manual + integration test with network disabled |
| NFR-03 | No blocking I/O on the UI thread for interactions rated "immediate" | Profiling; heavy aggregation isolated/cached |
| NFR-04 | Today renders smoothly with ≥200 active habits | Widget perf test / manual profiling |
| NFR-05 | 5+ years of history aggregates without perceptible UI jank | Seed-data benchmark test |
| NFR-06 | No plaintext secrets in source or storage | Code review; backup files contain no credentials (none exist) |
| NFR-07 | High unit-test coverage on recurrence/streak/adherence logic | `test/unit/` coverage report |
| NFR-08 | No continuous background polling; event/schedule-driven only | Code review of notification + reconciliation code |

## 6. Data Requirements

See `docs/DATA_MODEL.md` for the concrete Drift schema. Summary of entities (BRD
§13): `Habit`, `HabitSchedule`, `Reminder`, `CheckIn`, `AppSetting`. `HabitRevision`
and `Milestone` are deferred past the first working slice (§9.7) but the schema
reserves room for them.

## 7. Interface Requirements

- **Notifications**: `flutter_local_notifications` + `timezone` (already in
  `pubspec.yaml`).
- **File I/O**: `file_picker` + `share_plus` + `path_provider` (already present) for
  backup/export/restore via native picker/share sheet only — no server endpoint.
- **Charts**: `fl_chart` (already present) for trend/heatmap/weekday-performance
  visuals, each paired with a text-equivalent for accessibility (BRD §16).
- **No network interface** is part of the Habitly feature set. The existing
  `dio`/`ApiClient`/Firebase plumbing in this boilerplate is retained in the repo
  but Habitly features must not depend on it (see `docs/ARCHITECTURE.md` §6).

## 8. Acceptance Criteria

Reuse BRD §19.2 verbatim as the release gate: AC-01 through AC-12. Each `FR-xx`
above must have at least one automated test tracing to the AC(s) it supports before
Phase 5 (Polish & Release) is considered exit-ready.

## 9. Locked Decisions

Per BRD §21.1 ("Decisions to lock before development"):

1. **State management**: GetX (repo convention, `CLAUDE.md`). Satisfies BRD's
   "Riverpod, Bloc, or equivalent" — `BaseController.doAction<T>()` already gives
   testable, predictable async state.
2. **Database**: Drift over SQLite (BRD's own recommendation), via
   `sqlite3_flutter_libs` for mobile/desktop.
3. **Skip semantics**: skip excludes the occurrence from both the adherence
   denominator and the streak; it does not break an existing streak (BRD §8.3, §5).
4. **Weekly-quota multi-completion**: one occurrence per day counts once toward a
   weekly quota, regardless of extra taps, unless the habit type is Count (in which
   case the *value* accumulates but the day still counts as one occurrence).
5. **Edit effective-date model**: `HabitSchedule.effectiveFrom` + `Habit.updatedAt`
   only; no full `HabitRevision` snapshot table in the first working slice (revisit
   if audit/versioning is requested — table is reserved in the schema).
6. **Quiet hours**: suppress-only in MVP. No auto-reschedule to "next valid time"
   unless a future setting explicitly opts in (BRD's own MVP recommendation).
7. **Backup encryption**: not implemented in MVP. Plain JSON, since there is no
   account/password concept anywhere else in the app; revisit only if requested.
8. **Minimum platform versions**: Android minSdk 23 (Android 6.0) — required by
   `flutter_local_notifications` v21 and comfortably covers Drift's SQLite
   requirements; iOS 13.0 minimum.
9. **Visual language**: reuse the existing Material 3 adaptive color system in
   `lib/core/presentation/theme/` as-is (calm, low-saturation, dark-mode-complete
   already). No new design system introduced.

## 10. Traceability to BRD

Every `S01`–`S26` screen and every rule in BRD §5/§8 maps 1:1 into the FR list
above; no BRD requirement is weakened. Where an FR narrows an open BRD question
(marked "MVP recommended" in the BRD), §9 above is the single source of truth for
that decision going forward — do not re-litigate it per-feature.
