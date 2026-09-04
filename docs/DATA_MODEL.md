# Habitly — Data Model (Drift / SQLite)

> Concrete schema for the conceptual model in `docs/Habitly_AGENT.md` §13, built with
> Drift. Source of truth once implemented: `lib/core/data/database/tables/*.dart`.
> This file must be kept in sync with that code — update it in the same change that
> alters a table.

Engine: `sqlite3_flutter_libs` via `drift`. File: `habitly.sqlite` in
`getApplicationDocumentsDirectory()` (via `path_provider`).

## Conventions

- All primary keys: `id` = `TextColumn` UUID (stable across export/import — an
  `IntColumn` autoincrement would collide across a restore-onto-existing-data merge).
- Instant timestamps (`createdAt`, `updatedAt`, `achievedAt`): `DateTimeColumn`
  stored as UTC epoch millis (Drift default).
- Calendar dates (`localDate`, `startDate`, `endDate`, `effectiveFrom`): stored as
  `TextColumn` `YYYY-MM-DD` — deliberately *not* `DateTimeColumn`/UTC, so a habit's
  history is immune to timezone/DST rollover (BRD §13.1, SRS FR-52).
- Enums stored as `TextColumn` with a Dart `enum` wrapper at the DTO layer (per
  `CLAUDE.md`: DTOs own serialization, entities stay pure).

## Tables

### `habits`

| Column | Type | Notes |
| --- | --- | --- |
| id | text, PK | uuid |
| name | text | required, length-limited in domain validation |
| type | text | `binary` \| `count` \| `duration` \| `avoid` |
| icon | text | icon identifier/codepoint key |
| color | int | ARGB value |
| description | text, nullable | |
| unit | text, nullable | for count/duration (e.g. "glasses", "min") |
| target | real, nullable | normalized to stable storage unit (SRS FR-32) |
| goalDirection | text, nullable | `atLeast` \| `atMost` |
| sortOrder | int | for custom sort in Search/Filter (S18) |
| createdAt | datetime | UTC instant |
| updatedAt | datetime | UTC instant |
| archivedAt | datetime, nullable | soft-archive marker (BRD Core Rule "Archive") |

Index: `archivedAt`, `sortOrder`.

### `habit_schedules`

One *current* row per habit for the common case, plus a new row whenever the
schedule changes (append-only, never mutate a past row) — this is how "effective
date" edit semantics (SRS FR-13) are implemented without a full `HabitRevision`
snapshot table.

| Column | Type | Notes |
| --- | --- | --- |
| id | text, PK | uuid |
| habitId | text, FK → habits.id | indexed |
| mode | text | `daily` \| `weekdays` \| `timesPerWeek` \| `interval` |
| weekdays | text, nullable | CSV of ISO weekday ints (1=Mon..7=Sun), for `weekdays` mode |
| weeklyTarget | int, nullable | for `timesPerWeek` mode |
| intervalDays | int, nullable | for `interval` mode |
| anchorDate | text, nullable | interval anchor, `YYYY-MM-DD` |
| startDate | text | `YYYY-MM-DD` |
| endDate | text, nullable | `YYYY-MM-DD`, null = no end |
| effectiveFrom | text | `YYYY-MM-DD` — occurrences on/after this date use this row |

Index: `(habitId, effectiveFrom)`. Occurrence generation for a given date picks the
schedule row with the latest `effectiveFrom <= date`.

### `reminders`

| Column | Type | Notes |
| --- | --- | --- |
| id | text, PK | uuid |
| habitId | text, FK → habits.id | indexed |
| time | text | `HH:mm`, local intended time (BRD §13.1) |
| label | text, nullable | |
| enabled | boolean | default true |
| weekdays | text, nullable | CSV override; null = inherits habit schedule days |

Notification id at the platform layer = stable hash of `(habitId, id)` (SRS FR-50) —
not stored as its own column, derived deterministically so it never drifts from this
table.

### `check_ins`

| Column | Type | Notes |
| --- | --- | --- |
| id | text, PK | uuid |
| habitId | text, FK → habits.id | indexed |
| localDate | text | `YYYY-MM-DD`, the occurrence this resolves |
| value | real, nullable | logged amount (count/duration); null for binary |
| status | text | `completed` \| `partial` \| `missed` \| `skipped` |
| note | text, nullable | |
| createdAt | datetime | UTC instant |
| updatedAt | datetime | UTC instant |

Unique index: `(habitId, localDate)` — one resolved record per habit per scheduled
day (multiple taps update the same row, consistent with SRS FR-33). Index also on
`status` and `localDate` alone for calendar/insights range queries (BRD §12.1).

### `app_settings`

| Column | Type | Notes |
| --- | --- | --- |
| key | text, PK | |
| value | text | schema-versioned via a reserved `schema_version` key |

Existing `AppSettingsRepository`/`SharedPreference` already covers theme/locale;
this table is for Habitly-specific settings that benefit from being inside the same
transactional backup (start-of-week, time format, quiet-hours window, default
reminder snooze) rather than duplicating a second key-value store.

### `backup_meta` (not a persisted table — envelope shape only)

Written into the exported JSON file, not into `habitly.sqlite`:

```json
{
  "schemaVersion": 1,
  "appVersion": "1.0.0",
  "createdAt": "2026-09-04T12:00:00Z",
  "checksum": "sha256:...",
  "habits": [...],
  "habitSchedules": [...],
  "reminders": [...],
  "checkIns": [...],
  "appSettings": [...]
}
```

## Reserved for later (schema room, not built in Phase 0)

- `milestones` (`id`, `habitId`, `type`, `threshold`, `achievedAt`) — BRD §10.1;
  add when the motivation/celebration UI is built (Phase 3+), not before, since it's
  otherwise derivable from `check_ins` and storing it early risks drift.
- `habit_revisions` — only if product later needs full historical-definition
  snapshots beyond what `habit_schedules.effectiveFrom` covers (SRS §9 decision 5).

## Migration table

| Schema version | Change |
| --- | --- |
| 1 | Initial: `habits`, `habit_schedules`, `reminders`, `check_ins`, `app_settings` |

Every future row in this table must correspond to a `MigrationStrategy.onUpgrade`
step in `app_database.dart`, and to a migration test in `test/unit/database/` per
BRD §19.1.
