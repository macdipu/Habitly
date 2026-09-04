/// Habit success-rule type (docs/Habitly_AGENT.md BRD §8.1).
enum HabitType { binary, count, duration, avoid }

/// Recurrence rule shape (BRD §8.2).
enum ScheduleMode { daily, weekdays, timesPerWeek, interval }

/// Goal comparison direction. Binary habits ignore this.
enum GoalDirection { atLeast, atMost }

/// Persisted resolution of a single check-in row.
enum CheckInStatus { completed, partial, missed, skipped }

/// Fully-resolved state of one occurrence once schedule + check-in + "today"
/// are combined (BRD §8.4). [missed] and [pending] are never persisted as
/// rows — they're inferred at read time from the absence of a check-in.
enum OccurrenceState { pending, completed, partial, missed, skipped, notScheduled }
