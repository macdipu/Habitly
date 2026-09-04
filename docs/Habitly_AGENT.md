# Habitly — Coding Agent Specification

> Source: Habitly Business Requirements Document. This file is optimized for an autonomous coding agent implementing the Flutter application.

## Agent Mandate

Build **Habitly**, a production-quality, privacy-first, fully offline habit tracker for Android and iOS using Flutter. Treat the requirements below as the product contract. Do not add backend, authentication, cloud sync, telemetry, ads, subscriptions, or online dependencies unless explicitly requested.

### Non-negotiable engineering rules

- Flutter mobile app targeting Android and iOS.
- Fully usable indefinitely with no internet connection.
- No account, login, backend, or cloud dependency.
- Persist all user data locally in a relational database. Prefer **Drift + SQLite**.
- Use deterministic recurrence/streak logic that is unit-testable and independent from widgets.
- Historical check-ins must remain stable when a habit is edited later.
- Use local notifications only; reconcile schedules after relevant habit/settings changes.
- Never silently delete/reset the local database after an initialization or migration failure.
- All destructive actions require explicit confirmation where specified.
- Implement accessibility, dark mode, system theme, localization-ready strings, and responsive layouts.
- Separate domain, data, and presentation concerns. Avoid business logic in widgets.

### Recommended project structure

```text
lib/
  app/
    app.dart
    router.dart
    theme/
  core/
    database/
    notifications/
    backup/
    utils/
    widgets/
  features/
    onboarding/
    today/
    habits/
    calendar/
    insights/
    search/
    settings/
  domain/
    models/
    services/
    repositories/
test/
  unit/
  widget/
  integration/
```

### Implementation order

1. App shell, theme, navigation, preferences, database schema, migrations.
2. Habit domain model, recurrence engine, occurrence generation, check-in model.
3. Onboarding and Today screens.
4. Create/edit/archive/delete habit flows.
5. Habit detail, calendar, day history, undo/skip/notes.
6. Streak/adherence/statistics engine and Insights screens.
7. Local notifications and schedule reconciliation.
8. Search/filter/archive management.
9. Backup, restore, JSON/CSV export, validation.
10. Accessibility, edge-case hardening, unit/widget/integration tests, release QA.

### Definition of done for every feature

- UI matches the screen requirements and supports light/dark/system themes.
- State survives app restart.
- Offline behavior is complete; no network call is required.
- Relevant business logic has unit tests.
- Empty, loading, error, and destructive states are handled.
- Screen remains usable with large text and common phone sizes.
- No data loss when editing habits or changing preferences.

---

# Product Requirements

| Product | Habitly |
| --- | --- |
| Document Type | Business Requirements Document (BRD) + UI/UX Functional Specification |
| Platform | Flutter mobile app - Android and iOS |
| Operating Model | Fully offline; local-first; no mandatory account or server |
| Version | 1.0 - Implementation baseline |

Product principle: Make consistency visible, rewarding, private, and effortless.

## Document Map

| Section | Coverage |
| --- | --- |
| 1 | Executive Summary |
| 2 | Product Vision, Goals & Success Metrics |
| 3 | Users, Personas & Jobs To Be Done |
| 4 | Scope, Assumptions & Constraints |
| 5 | Core Product Rules |
| 6 | Information Architecture & Navigation |
| 7 | Screen-by-Screen UI/UX Requirements |
| 8 | Habit Logic & Functional Rules |
| 9 | Notifications & Reminder Engine |
| 10 | Statistics, Insights & Gamification |
| 11 | Offline Architecture & Local Data |
| 12 | Flutter Technical Requirements |
| 13 | Data Model |
| 14 | Backup, Export, Restore & Privacy |
| 15 | Non-Functional Requirements |
| 16 | Accessibility, Localization & Theming |
| 17 | Error, Empty & Edge States |
| 18 | Analytics Without a Server |
| 19 | Testing & Acceptance Criteria |
| 20 | MVP / Phase Roadmap |
| 21 | Open Product Decisions & Future Expansion |

## 1. Executive Summary

Habitly is a fully offline, privacy-first habit tracking application built with Flutter for Android and iOS. The app helps users create repeatable behaviors, record completion with minimal friction, maintain streaks, review progress, and learn from trends without requiring an account, internet connection, or cloud service.

| MVP promise  A user should be able to install Habitly, create a habit, schedule reminders, track it every day, see streaks and statistics, back up their data, and restore it later - all without internet access. |
| --- |

### 1.1 Product positioning

- Simple enough for daily use in under 30 seconds.

- Powerful enough to support daily, weekly, selected-day, target-count, and avoidance habits.

- Private by default: all personal data remains on the device unless the user explicitly exports or backs it up.

- Motivating without punishment: missed days are represented neutrally; the UX emphasizes restarting and consistency rather than guilt.

### 1.2 Primary business requirement

Deliver a production-ready mobile habit tracker that can operate indefinitely without a backend. The product must preserve user data reliably on-device, provide predictable recurring scheduling, support local notifications, and maintain accurate history and statistics across app restarts, device reboots, timezone changes, and long periods of use.

## 2. Product Vision, Goals & Success Metrics

### 2.1 Vision

Habitly turns small repeated actions into a clear visual record of progress. The product should feel calm, fast, encouraging, and trustworthy. It should avoid the complexity of project-management tools and the pressure-heavy tone of competitive fitness apps.

### 2.2 Product goals

| Goal | Requirement | Target |
| --- | --- | --- |
| Fast capture | Log the most common habit state from Home in one tap. | <= 2 interactions |
| Reliable offline use | Every core feature works in airplane mode. | 100% core flows |
| Low setup friction | Create a basic habit quickly. | < 60 sec typical |
| Data durability | No loss of valid habit history on normal restart/update. | Zero-loss expectation |
| Readable progress | Daily status and streak are understandable at a glance. | Immediate comprehension |
| User control | Users can edit, archive, export, and delete their own data. | All local data |

### 2.3 Suggested product KPIs

Because the app is fully offline, these are primarily local product-quality indicators unless a future opt-in telemetry system is introduced.

- Activation: user creates at least one habit and records one completion.

- Habit logging frequency: number of days with at least one check-in.

- Habit adherence rate: completed scheduled occurrences / scheduled occurrences.

- Reminder usefulness: reminder-to-completion association measured locally, if enabled.

- Retention proxy: locally computed active days over 7, 30, and 90 days.

## 3. Users, Personas & Jobs To Be Done

| Persona | Need | Pain Point | Habitly Response |
| --- | --- | --- | --- |
| Beginner | Start 2-4 simple routines | Too many settings | Quick-create presets and sensible defaults |
| Consistency seeker | Protect streaks and remember routines | Forgets or loses momentum | Reminders, streak visibility, recovery-friendly UX |
| Self-quantifier | Understand patterns over time | Raw checkmarks are not insightful | Calendar heatmap, adherence %, trends, best periods |
| Privacy-focused user | Track personal behaviors privately | Does not want accounts/cloud | Local-only database and explicit export |

### 3.1 Jobs to be done

- When I decide to build a routine, I want to define it in a few steps so I can start today.

- When a habit is due, I want to know exactly what I need to do and record it immediately.

- When I miss a day, I want to continue without feeling that all progress is lost.

- When I review my month, I want to see whether I am actually becoming more consistent.

- When I change or replace my phone, I want a safe way to move my Habitly data without an account.

## 4. Scope, Assumptions & Constraints

### 4.1 MVP in scope

- Onboarding and local profile preferences

- Habit create/edit/archive/delete

- Daily, specific weekdays, custom interval and weekly frequency schedules

- Binary, count-based, duration-based and quit/avoidance habits

- Home dashboard and daily timeline

- Check-in, undo, skip and optional notes

- Multiple local reminders per habit

- Streaks, adherence, calendar history, weekly/monthly insights

- Search/filter/archive management

- Themes, dark mode, start-of-week, time format and accessibility settings

- Local backup, restore, CSV/JSON export

- No-account operation and local database migration support

### 4.2 Explicitly out of MVP

- User accounts and authentication

- Cloud synchronization

- Social feed, friends or public leaderboards

- Web dashboard

- Shared family/team habits

- Payments/subscriptions

- Wearable integration

- AI coaching requiring online inference

- Server-side push notifications

### 4.3 Constraints

- The app must remain usable when the device has no network connectivity for an unlimited period.

- Local notification behavior is subject to Android/iOS OS restrictions and permissions.

- Device backup behavior must not be treated as the app's primary backup mechanism; Habitly must provide explicit export/backup.

- Historical records must be stable even if a habit definition changes later.

## 5. Core Product Rules

| Rule | Definition |
| --- | --- |
| Local-first truth | The on-device database is the sole source of truth in MVP. |
| Occurrence-based tracking | Habit status is evaluated against scheduled occurrences, not simply every calendar day. |
| Immutable history principle | Editing a habit should not silently rewrite past completion records. |
| Day boundary | A configurable local day boundary may be supported later; MVP defaults to local calendar midnight. |
| Streak | Consecutive scheduled occurrences meeting the habit success rule; non-scheduled days do not break the streak. |
| Skip | A user-declared non-required occurrence. By default, skipped occurrences are excluded from adherence denominator and do not increment the streak. |
| Archive | Stops future scheduling/reminders while preserving all history. |
| Delete | Permanent removal after confirmation; offer export/backup beforehand where practical. |

## 6. Information Architecture & Navigation

Recommended primary navigation uses a bottom navigation bar with four persistent destinations and one central create action. This keeps daily check-in separate from deeper analysis and settings.

| Destination | Purpose | Primary Content |
| --- | --- | --- |
| Today | Immediate daily execution | Due habits, progress ring, quick log, day navigation |
| Calendar | Historical review | Month heatmap, selected-day records, habit history |
| Insights | Progress analysis | Streaks, adherence, trends, totals, milestones |
| Settings | App control | Appearance, reminders, data, backup, privacy, about |
| Create (+) | Global action | New habit creation flow |

| Navigation rule  The user must always be able to return to Today with one tap from any primary destination. Creation uses a dedicated flow and should preserve an unfinished draft when the user temporarily leaves the app. |
| --- |

## 7. Screen-by-Screen UI/UX Requirements

This section is the primary implementation specification for design and Flutter UI development. Screen IDs should be used in tickets, QA cases, and design files.

### S01 - Splash / App Bootstrap

Purpose: Fast launch while local storage, migrations, settings, and scheduled-notification state are initialized.

#### UI components

- Habitly wordmark or compact logo centered

- No marketing carousel

- Optional subtle loading indicator only if bootstrap exceeds ~300 ms

- Respect current theme immediately to avoid white flash

#### Behavior / interactions

- Run DB migration

- Load app preferences

- Detect first launch

- Reconcile notification schedules if required

- Navigate to Onboarding or Today

#### UX / acceptance notes

- If DB initialization fails, show a recoverable error with Restore Backup / Retry options; never silently reset data.

### S02 - Welcome

Purpose: Explain value and offline/privacy model in one screen.

#### UI components

- Headline: Build better days, one habit at a time

- Three concise benefits: track, remember, understand progress

- Primary button: Get Started

- Secondary text: Your data stays on this device

#### Behavior / interactions

- Continue to basic preferences

#### UX / acceptance notes

- No sign-up, login, email, or network prompt.

### S03 - Onboarding Preferences

Purpose: Set global defaults without blocking first use.

#### UI components

- Start of week: Monday/Sunday

- Time format: system/12h/24h

- Notification permission explainer

- Theme: system/light/dark

- Continue button

#### Behavior / interactions

- Persist choices locally

- Request OS notification permission only after contextual explanation

#### UX / acceptance notes

- All fields have defaults; user can continue immediately.

### S04 - Today - Empty State

Purpose: First-use home screen that drives habit creation.

#### UI components

- Date header and greeting-neutral copy

- Empty illustration/icon

- Message: No habits yet

- Primary CTA: Create your first habit

- Optional quick presets: Drink water, Read, Exercise, Sleep on time

#### Behavior / interactions

- Preset tap opens Create Habit with prefilled values

#### UX / acceptance notes

- Avoid decorative clutter; the create CTA is dominant.

### S05 - Today - Dashboard

Purpose: Primary daily habit execution screen.

#### UI components

- Top app bar: date, previous/next day affordance, overflow/search

- Daily progress: completed / due with small progress ring or bar

- Sections: Due now, Later today, Completed; optional All habits toggle

- Habit cards with icon/color, title, target, streak, reminder time, status control

- Floating/central + button

#### Behavior / interactions

- Single tap on status control records success

- Tap card opens Habit Detail

- Long press or overflow: edit, skip today, archive

- Pull-to-refresh is unnecessary because data is local

#### UX / acceptance notes

- Completed cards remain visible but visually quieter; avoid reordering while user is tapping unless predictable.

### S06 - Quick Check-in Sheet

Purpose: Record non-binary habits with minimal interruption.

#### UI components

- Habit name

- Current value and target

- Increment/decrement or numeric entry

- For duration: quick chips such as +5, +10, +30 min

- Optional note link

- Save / Done

#### Behavior / interactions

- Update occurrence record

- Trigger milestone animation only when target transitions to achieved

#### UX / acceptance notes

- Must work one-handed and dismiss safely without accidental save.

### S07 - Create Habit - Basics

Purpose: Define identity and habit type.

#### UI components

- Name field with character limit

- Icon picker

- Color picker with accessible contrast

- Habit type: Yes/No, Count, Duration, Avoid/Quit

- Optional description

- Next button

#### Behavior / interactions

- Validate name

- Store draft locally/in memory until flow completion

#### UX / acceptance notes

- Suggested default color/icon may be assigned automatically but remain editable.

### S08 - Create Habit - Schedule

Purpose: Define when the habit is expected.

#### UI components

- Frequency choices: Every day, Specific days, X times/week, Interval

- Weekday chips for selected-days mode

- Start date

- Optional end date or no end

- Preview sentence, e.g., Mon, Wed, Fri starting Sep 2

#### Behavior / interactions

- Validate schedule

- Generate next occurrences dynamically rather than pre-creating years of rows

#### UX / acceptance notes

- Schedule preview is mandatory; invalid zero-day selections cannot continue.

### S09 - Create Habit - Goal

Purpose: Define measurable success.

#### UI components

- Binary: completion only

- Count: target number + unit

- Duration: target minutes/hours

- Avoid: default target is zero occurrences; allow maximum threshold later

- Goal direction: at least / at most where applicable

#### Behavior / interactions

- Normalize values to stable storage units

#### UX / acceptance notes

- Examples shown inline; numeric input prevents negative targets.

### S10 - Create Habit - Reminders

Purpose: Configure local reminders.

#### UI components

- Reminder toggle

- One or more times

- Optional reminder label

- Day-specific reminders inherit schedule

- Permission status notice

- Add another reminder

#### Behavior / interactions

- Schedule local notifications only after habit save

- If permission denied, save habit without reminders and show non-blocking guidance

#### UX / acceptance notes

- Never make reminder permission a requirement for habit creation.

### S11 - Create Habit - Review

Purpose: Final confirmation before creating habit.

#### UI components

- Summary card: icon, name, schedule, target, reminders

- Edit links for each section

- Create Habit button

- Optional Start today toggle when schedule allows

#### Behavior / interactions

- Persist habit transactionally

- Schedule notifications

- Return to Today and highlight created habit

#### UX / acceptance notes

- Creation should be atomic: if scheduling fails, habit remains saved and user is informed reminders need attention.

### S12 - Habit Detail

Purpose: Full overview of one habit.

#### UI components

- Hero area with icon, title, current streak, best streak

- Today status/control

- Schedule and goal summary

- 7/30-day adherence

- Mini calendar/heatmap

- Recent notes/check-ins

- Actions: Edit, Pause/Archive, Delete

#### Behavior / interactions

- Tap date opens Day Detail

- Tap stats opens filtered Insights

#### UX / acceptance notes

- Past records remain accessible for archived habits.

### S13 - Edit Habit

Purpose: Modify future behavior without corrupting history.

#### UI components

- Same fields as create

- Banner explaining changes apply going forward

- Save changes

- Destructive actions separated

#### Behavior / interactions

- Cancel/reschedule future reminders

- Persist updated definition

- Preserve historical records

#### UX / acceptance notes

- If schedule changes, previously completed dates remain unchanged; future due-state uses new schedule from effective date.

### S14 - Calendar - Month

Purpose: Visual history across time.

#### UI components

- Month header with navigation

- Calendar grid

- Day markers: success/partial/missed/none

- Optional filter by habit

- Monthly completion summary

- Tap day for detail

#### Behavior / interactions

- Compute status from occurrences and records

#### UX / acceptance notes

- Do not color unscheduled days as failures.

### S15 - Day Detail

Purpose: Explain exactly what happened on a selected date.

#### UI components

- Date and daily summary

- Scheduled habit list

- Status per habit

- Logged value/time

- Note indicators

- Edit check-in where allowed

#### Behavior / interactions

- Add/edit/remove historical check-ins

- Recalculate insights immediately

#### UX / acceptance notes

- Historical edits require explicit save and should update streak calculations deterministically.

### S16 - Insights Overview

Purpose: High-level progress dashboard.

#### UI components

- Date range selector: 7d / 30d / 90d / year / all

- Overall adherence

- Current streak highlights

- Most consistent habit

- Completion trend chart

- Habit ranking table

- Milestones

#### Behavior / interactions

- Filter and recalculate locally

#### UX / acceptance notes

- Charts include text equivalents/labels for accessibility.

### S17 - Habit Insights

Purpose: Detailed analytics for one habit.

#### UI components

- Current/best streak

- Adherence percentage

- Successful vs scheduled occurrences

- Weekday performance

- Monthly trend

- Calendar heatmap

- Average value for count/duration habits

- Total accumulated amount

#### Behavior / interactions

- Date range and aggregation controls

#### UX / acceptance notes

- Avoid misleading averages when no scheduled occurrences exist; display Not enough data.

### S18 - Search & Filter

Purpose: Find and manage habits quickly.

#### UI components

- Search field

- Filters: active, archived, type, color/category

- Sort: custom, name, streak, adherence, created date

- Clear filters

#### Behavior / interactions

- Local indexed search where needed

#### UX / acceptance notes

- Persist preferred sort optionally.

### S19 - Archived Habits

Purpose: Manage inactive habits while preserving history.

#### UI components

- Archived list

- Archive date

- Restore action

- Delete action

- Search

#### Behavior / interactions

- Restoring reactivates future scheduling from restore date unless user edits schedule

#### UX / acceptance notes

- No historical reminders should be rescheduled.

### S20 - Settings Home

Purpose: Central configuration area.

#### UI components

- Appearance

- Reminders & notifications

- Habit defaults

- Calendar preferences

- Data & backup

- Privacy

- Accessibility

- About

#### Behavior / interactions

- Navigate to sub-settings

#### UX / acceptance notes

- No settings require network access.

### S21 - Appearance Settings

Purpose: Control visual presentation.

#### UI components

- Theme: system/light/dark

- Accent color

- Compact/comfortable habit card density

- Reduce motion toggle

- App icon variants optional later

#### Behavior / interactions

- Persist settings and apply instantly

#### UX / acceptance notes

- All semantic colors must retain WCAG-appropriate contrast.

### S22 - Notification Settings

Purpose: Global reminder controls.

#### UI components

- OS permission status

- Master reminders toggle

- Default snooze duration

- Quiet hours

- Reminder sound/vibration options where OS permits

- Open system settings button

#### Behavior / interactions

- Reconcile scheduled notifications when global setting changes

#### UX / acceptance notes

- Quiet hours behavior must be documented: delay or suppress; recommended MVP = suppress and show next valid reminder only if configured.

### S23 - Data & Backup

Purpose: Give users ownership of local data.

#### UI components

- Create backup

- Restore backup

- Export CSV

- Export JSON

- Import data if supported

- Last backup timestamp stored locally

- Delete all data

#### Behavior / interactions

- Use native file picker/share sheet

- Validate backup schema/version before restore

#### UX / acceptance notes

- Restore requires confirmation and pre-restore safety backup when feasible.

### S24 - Backup/Restore Flow

Purpose: Safe migration between devices.

#### UI components

- Backup description

- Optional password-protected encrypted backup if implemented

- Choose file destination/share

- Restore file picker

- Validation summary: habits, records, settings

- Confirm replace/merge strategy

#### Behavior / interactions

- MVP recommended restore strategy: replace local dataset after automatic safety snapshot

#### UX / acceptance notes

- Never import a corrupt file partially. Use transaction + rollback.

### S25 - Privacy & About

Purpose: Explain offline model and application metadata.

#### UI components

- Privacy statement: no account required; data stored locally

- Data storage summary

- App version/build

- Licenses

- Feedback link only if deliberately added later

#### Behavior / interactions

- No background analytics transmission in MVP

#### UX / acceptance notes

- Keep privacy language plain and specific.

### S26 - Delete Confirmation

Purpose: Prevent accidental destructive actions.

#### UI components

- Item name

- Consequences

- Optional export first CTA

- Cancel

- Delete permanently

#### Behavior / interactions

- Require second explicit action

#### UX / acceptance notes

- For delete-all-data, require typed confirmation such as DELETE or equivalent.

## 8. Habit Logic & Functional Rules

### 8.1 Habit types

| Type | Success Rule | Example | UI Control |
| --- | --- | --- | --- |
| Binary | Completed once for scheduled occurrence | Read 10 pages | Check button |
| Count | Recorded value >= target | Drink 8 glasses | Stepper/value |
| Duration | Recorded duration >= target | Meditate 20 min | Timer/value |
| Avoid/Quit | No undesired event, or value <= threshold | No soda | Success / slip log |

### 8.2 Schedule types

- Daily: every calendar day from effective start date.

- Specific weekdays: only selected local weekdays count as scheduled occurrences.

- X times per week: weekly quota where any selected days may satisfy the target; MVP should clearly define whether multiple completions in one day count (recommended: one occurrence/day unless count habit).

- Interval: every N days from anchor/start date.

- Optional future: multiple times/day, monthly rules, specific dates, habit stacking.

### 8.3 Streak calculation

- Determine all scheduled occurrences up to the evaluated local date.

- Evaluate each occurrence as success, miss, skip, or pending.

- Starting from the most recent resolved scheduled occurrence, count backward while each applicable occurrence meets the success rule.

- Non-scheduled days are ignored. Pending occurrences later today must not break a streak.

- Skipped occurrences do not increment the streak and, by default, do not break it. This rule must be explicit in UX copy.

### 8.4 Check-in states

| State | Meaning | Visual Treatment |
| --- | --- | --- |
| Pending | Scheduled but not yet resolved | Neutral |
| Completed | Success threshold reached | Positive/check |
| Partial | Some value logged, below target | Progress indicator |
| Missed | Scheduled date passed without success | Muted/neutral negative |
| Skipped | Explicitly excluded by user | Distinct dash/skip |
| Not scheduled | No occurrence expected | No failure styling |

## 9. Notifications & Reminder Engine

- Use local notifications only; no remote push infrastructure.

- Each reminder maps to a stable habit/reminder identifier so it can be cancelled and rescheduled.

- On habit edit/archive/delete, cancel affected pending notifications before rescheduling.

- On app startup, periodically reconcile expected schedules against stored notification metadata where platform limits make this necessary.

- Notification tap deep-links to the associated habit or a quick check-in action if supported safely.

- Use timezone-aware scheduling. After timezone change, future reminders should reflect the user's local intended time.

- Android exact-alarm permission should not be requested unless the product truly requires exact delivery; tolerate normal OS scheduling variance where appropriate.

| Reliability note  Mobile operating systems may delay or suppress notifications due to battery optimization, Focus/Do Not Disturb modes, permission state, or platform policies. Habitly should communicate this transparently and never infer a missed habit solely from notification delivery. |
| --- |

## 10. Statistics, Insights & Gamification

| Metric | Formula / Rule | Display |
| --- | --- | --- |
| Adherence % | successful scheduled occurrences / eligible scheduled occurrences x 100 | 0-100%, with sample size |
| Current streak | consecutive eligible successes through most recent resolved occurrence | Integer + unit |
| Best streak | maximum historical consecutive success run | Integer + date range optional |
| Completion total | number of successful occurrences | Integer |
| Count/duration total | sum of logged values in selected period | Value + unit |
| Average value | mean logged value over relevant occurrences | Value + unit |
| Weekday success | successes / scheduled occurrences by weekday | Bar chart + % |

### 10.1 Motivation system

- Use lightweight milestones such as 3, 7, 14, 30, 50, 100 successful occurrences or streaks.

- Celebrations should be brief and skippable; respect Reduce Motion.

- Avoid leaderboards, shame-based messages, loss-framed copy, or manipulative engagement loops.

- A streak is a feedback tool, not the user's identity. Missed days should lead to restart-oriented copy such as Continue today.

## 11. Offline Architecture & Local Data

Habitly should be designed as an offline-first application from the first line of code. No repository or use case should assume that network access is available. The local persistence layer is the authoritative state store.

### 11.1 Recommended architecture

- Presentation: Flutter widgets + state management.

- Domain: entities, value objects, scheduling logic, streak/statistics services, validation rules.

- Data: repositories backed by a local relational database.

- Platform services: notifications, file export/import, timezone, secure storage if encrypted backup keys are used.

- No network data source in MVP. Keep interfaces abstract enough that optional sync can be added later without rewriting domain logic.

### 11.2 Persistence recommendation

Use a structured local database suitable for migrations, queries, and transactional integrity. SQLite via Drift is a strong fit for a habit tracker with relational history and analytics. Isar/ObjectBox can also work, but a relational model makes occurrence and history queries explicit and portable. The BRD does not mandate one package, but the implementation must support versioned migrations and atomic writes.

### 11.3 Offline guarantees

- Create/edit/check-in/history/statistics/settings all function with airplane mode enabled.

- No UI spinner waits for network for core workflows.

- App cold start does not make a blocking network call.

- Export and backup use device file APIs/share sheets only.

- Any future online features must be isolated and optional.

## 12. Flutter Technical Requirements

| Area | Requirement | Suggested Implementation |
| --- | --- | --- |
| Architecture | Feature-oriented clean separation; business logic testable without widgets | Feature-first + domain/data/presentation layers |
| State management | Predictable, testable state | Riverpod, Bloc, or equivalent |
| Database | Versioned local DB with transactions and indexes | Drift/SQLite recommended |
| Notifications | Cross-platform local scheduling | flutter_local_notifications or equivalent |
| Timezone | Timezone-aware reminder scheduling | timezone + platform timezone package |
| Navigation | Typed/declarative route handling | go_router or equivalent |
| Serialization | Stable backup schema and models | json_serializable/freezed optional |
| Charts | Accessible local chart rendering | fl_chart or equivalent |
| File access | Export/restore via native picker/share | file_picker/share_plus/path_provider |
| Testing | Unit, widget, integration and migration tests | flutter_test + integration_test |

### 12.1 Performance requirements

- Today screen should render smoothly with at least 200 active habits, although normal usage is expected to be much lower.

- Statistics calculations over 5+ years of history should complete without blocking the UI thread perceptibly; cache or isolate heavy aggregation as needed.

- Database indexes should cover habit_id, date/occurrence date, status, archive state, and reminder foreign keys.

- Avoid eagerly generating one database row for every future occurrence indefinitely. Compute recurrence or generate bounded windows.

## 13. Data Model

The model below is conceptual. Exact field names may differ, but the semantics and relationships should be preserved.

| Entity | Key Fields | Purpose | Notes |
| --- | --- | --- | --- |
| Habit | id, name, type, icon, color, unit, target, createdAt, archivedAt | Current habit definition | Soft archive; avoid using mutable fields as history source |
| HabitSchedule | id, habitId, mode, weekdays, interval, weeklyTarget, startDate, endDate, effectiveFrom | Recurrence rule | Version or effective-date changes if preserving rule history |
| Reminder | id, habitId, time, enabled, label | Local notification definitions | May support multiple reminders |
| CheckIn | id, habitId, localDate, value, status, note, createdAt, updatedAt | User record for an occurrence | Unique constraints depend on habit type |
| HabitRevision | id, habitId, effectiveFrom, snapshotJson/fields | Optional historical definition snapshot | Recommended if edit semantics become complex |
| AppSetting | key, value | Local preferences | Schema-versioned |
| Milestone | id, habitId, type, threshold, achievedAt | Avoid repeated celebration | Can be derived but stored for UX state |
| BackupMeta | schemaVersion, createdAt, appVersion, checksum | Backup validation | Stored inside backup package |

### 13.1 Date/time rules

- Store timestamps in UTC where they represent instants (createdAt, updatedAt).

- Store user-facing habit occurrence dates as local calendar dates independent of UTC rollover.

- Store reminder intended local time separately from absolute scheduled timestamp.

- Persist timezone identifiers where needed for correct rescheduling.

## 14. Backup, Export, Restore & Privacy

### 14.1 Backup requirements

- Generate a versioned backup containing habits, schedules, reminders, check-ins, settings, and required metadata.

- Include schema version and integrity checksum.

- Backup creation must not mutate current data.

- Restore must validate file format and schema before writing.

- Restore should occur in one transaction or a staged database replacement with rollback.

- Before destructive restore, create an automatic temporary safety backup where storage permits.

### 14.2 Export formats

- CSV: human-readable check-in/history export, potentially one file per logical table or a flattened history file.

- JSON: complete structured export suitable for backup/advanced users.

- Date/time and units must be unambiguous in exported data.

### 14.3 Privacy requirements

- No account, advertising identifier, contact list, precise location, or remote analytics is required for MVP.

- Request only OS permissions necessary for user-enabled features.

- Do not embed sensitive habit names or notes in notification text unless the user chooses notification detail level; provide a privacy-friendly generic option.

- Provide Delete All Data in Settings with clear confirmation.

## 15. Non-Functional Requirements

| Category | Requirement | Acceptance Direction |
| --- | --- | --- |
| Reliability | No valid check-in or habit change is lost after successful save. | Transactional writes + crash/restart tests |
| Availability | Core features operate without internet. | Full airplane-mode test suite |
| Performance | Common interactions feel immediate. | No blocking I/O on main thread |
| Security | Use platform sandbox; protect exported backups as designed. | No plaintext secret keys in source/storage |
| Maintainability | Business rules are isolated and unit-testable. | High coverage for recurrence/streak logic |
| Compatibility | Support a defined recent Android/iOS baseline. | CI matrix + device testing |
| Battery | No continuous background polling. | Event/schedule-driven architecture |
| Storage | History scales for multi-year use. | Efficient DB + bounded caching |

## 16. Accessibility, Localization & Theming

- Support Dynamic Type / text scaling without clipping critical controls.

- Minimum comfortable tap target sizes consistent with platform accessibility guidance.

- Every icon-only action has a semantic label/tooltip.

- Do not encode habit status by color alone; pair color with icon/shape/text.

- Support screen readers for progress, charts, calendar cells, and check-in controls.

- Respect system dark mode and provide explicit theme override.

- Respect Reduce Motion where available or via app setting.

- Externalize all strings for localization from the beginning, even if MVP ships in one language.

- Use locale-aware first day of week, date formatting, pluralization, and 12/24-hour time display.

- Design layouts to tolerate longer translated strings and right-to-left languages in future.

## 17. Error, Empty & Edge States

| Scenario | Expected UX | Data Rule |
| --- | --- | --- |
| Notification denied | Non-blocking banner + Open Settings action | Habit still saves normally |
| No habits | Purposeful empty state with Create CTA | No fake/sample records unless user chooses preset |
| No insight data | Explain that more check-ins are needed | No zero-as-real-data chart |
| Timezone change | Reschedule future reminders | Historical local dates stay stable |
| DST transition | Honor intended local reminder time | Avoid duplicate check-ins |
| Device clock change | Re-evaluate pending states on resume | Do not rewrite past timestamps |
| Corrupt backup | Reject with clear error | No partial restore |
| Database migration failure | Recovery screen with retry/restore/export options where possible | Never auto-delete DB |
| Habit archived today | Remove future reminders; preserve today record | History remains |
| Target reduced after partial log | Recalculate current/future success under effective definition | Past resolved history remains stable according to revision policy |

## 18. Analytics Without a Server

Habitly can provide meaningful analytics entirely on-device. These analytics are user-facing calculations, not remote telemetry.

- Daily/weekly/monthly adherence trends

- Streak distribution

- Best weekday

- Consistency by time period

- Average count or duration

- Total cumulative values

- Habit completion correlation may be considered later but should avoid implying causation

- All derived metrics should be reproducible from stored local history

| Optional future telemetry  If product analytics are ever introduced, they should be separate from the offline core, opt-in where appropriate, privacy-preserving, and never required for functionality. This is outside MVP. |
| --- |

## 19. Testing & Acceptance Criteria

### 19.1 Critical functional test suites

- Recurrence generation across weekdays, intervals, leap years, month/year boundaries, and start/end dates.

- Streak calculation with scheduled days, skipped days, missed days, partials, future/pending dates, and edited history.

- Habit editing effective-date behavior and historical stability.

- Notification create/update/archive/delete and timezone rescheduling.

- Backup/restore round-trip equality across supported schema versions.

- Database migration from every released schema version to current.

- Airplane-mode end-to-end operation.

- Theme/text scaling/accessibility traversal.

- Cold-start and process-death persistence.

### 19.2 MVP release acceptance criteria

| ID | Acceptance Criterion |
| --- | --- |
| AC-01 | User can complete onboarding without internet or account. |
| AC-02 | User can create each supported habit type and schedule. |
| AC-03 | User can check in from Today and undo/edit the record. |
| AC-04 | Current streak and adherence recalculate correctly after a check-in. |
| AC-05 | User can review any historical day with stored records. |
| AC-06 | Local reminders can be enabled/disabled and are rescheduled on edit. |
| AC-07 | Archived habits disappear from future due lists and retain history. |
| AC-08 | User can export a backup and restore it on a clean installation. |
| AC-09 | Core experience passes airplane-mode test from install through long-term use. |
| AC-10 | App survives force close/reopen with no successful-write data loss. |
| AC-11 | All destructive data actions require explicit confirmation. |
| AC-12 | No critical screen clips or becomes unusable at large text scale. |

## 20. MVP / Phase Roadmap

| Phase | Objective | Features | Exit Condition |
| --- | --- | --- | --- |
| Phase 0 | Foundation | Architecture, database schema, theme system, navigation, recurrence engine, test harness | Core domain tests green |
| Phase 1 | Tracking MVP | Onboarding, Today, create/edit habit, check-ins, archive | Daily use possible offline |
| Phase 2 | Reminders | Local notifications, permissions, timezone handling, deep links | Reliable reminder lifecycle |
| Phase 3 | History & Insights | Calendar, day detail, streaks, adherence, charts | Progress review complete |
| Phase 4 | Data ownership | Backup, restore, CSV/JSON export, delete-all | Device migration validated |
| Phase 5 | Polish & Release | Accessibility, localization readiness, edge states, performance, store QA | Release checklist passed |

## 21. Open Product Decisions & Future Expansion

### 21.1 Decisions to lock before development

- State-management package (Riverpod vs Bloc/equivalent).

- Database package (Drift recommended baseline).

- Exact skip/streak semantics.

- Weekly quota behavior and whether multiple same-day completions can count.

- Habit edit effective-date/versioning implementation.

- Notification quiet-hours behavior.

- Backup encryption requirement and password UX.

- Minimum Android/iOS versions.

- Default app visual language and brand palette.

### 21.2 Future candidates

- Widgets for home/lock screen

- Wear OS / watchOS companion

- Optional encrypted device-to-device sync

- Habit templates and routine bundles

- Habit stacking and dependencies

- Mood/journal linkage

- Health platform integrations with explicit permissions

- Focus timer for duration habits

- Optional AI summaries performed on-device when feasible

- Shared accountability features as a separate online module

## Implementation North Star

| 1. One tap beats one screen  The core daily action - recording a habit - should be available directly from Today whenever the habit type permits it. |
| --- |

| 2. Offline is not a fallback  No core feature should degrade merely because the device is disconnected. |
| --- |

| 3. History is sacred  Edits to a habit must not unexpectedly rewrite what the user actually logged in the past. |
| --- |

| 4. Motivation without pressure  Use streaks, milestones, and visual progress as feedback, not as punishment. |
| --- |

| 5. Data belongs to the user  Backup, export, restore, archive, and delete must be understandable and reliable. |
| --- |

End of BRD • Habitly v1.0

---

## Agent Completion Checklist

Before declaring the application complete, verify all of the following:

- [ ] S01–S26 implemented and navigable.
- [ ] Create, edit, archive, restore, and delete habit flows work without data corruption.
- [ ] Daily, selected-weekday, weekly-frequency, and custom-interval schedules are deterministic.
- [ ] Binary, count, duration, and quit/avoidance habit types are supported as specified.
- [ ] Check-in, undo, skip, notes, and historical edits behave correctly.
- [ ] Streak, adherence, completion-rate, calendar, and insight calculations have tests.
- [ ] App restart and device reboot do not lose state.
- [ ] Notification scheduling/reconciliation is implemented and permission-safe.
- [ ] Timezone/DST changes do not duplicate or destroy historical records.
- [ ] Backup and restore validates data before replacing the active database.
- [ ] CSV/JSON export produces usable files.
- [ ] No network permission or backend is required for core operation.
- [ ] Light, dark, and system themes work.
- [ ] Large-text/accessibility pass completed.
- [ ] Destructive actions use confirmation UX.
- [ ] Database migrations have tests and never silently wipe user data.
- [ ] Release build passes unit, widget, and critical integration tests.

## Agent Behavior While Implementing

When a requirement is ambiguous, choose the option that preserves user data, remains fully offline, minimizes surprise, and keeps domain logic deterministic. Record material assumptions in code comments or project documentation rather than silently changing product behavior. Do not weaken requirements merely to simplify implementation.