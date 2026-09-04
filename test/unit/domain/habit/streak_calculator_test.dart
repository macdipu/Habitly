import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/streak_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calc = StreakCalculator();
  const c = OccurrenceState.completed;
  const m = OccurrenceState.missed;
  const p = OccurrenceState.partial;
  const s = OccurrenceState.skipped;
  const pending = OccurrenceState.pending;

  group('StreakCalculator.currentStreak', () {
    test('counts consecutive completions back from the most recent day', () {
      expect(calc.currentStreak([c, c, c]), 3);
    });

    test('stops at the first miss walking backward', () {
      expect(calc.currentStreak([c, c, m, c, c, c]), 3);
    });

    test('a trailing partial breaks the streak like a miss', () {
      expect(calc.currentStreak([c, c, c, p]), 0);
    });

    test('a skipped day does not break or extend the streak', () {
      expect(calc.currentStreak([c, c, m, s, c, c]), 2);
    });

    test('a pending occurrence (today, not yet checked in) does not break the streak', () {
      expect(calc.currentStreak([c, c, c, pending]), 3);
    });

    test('all misses yields a zero streak', () {
      expect(calc.currentStreak([m, m, m]), 0);
    });

    test('empty history yields a zero streak', () {
      expect(calc.currentStreak([]), 0);
    });
  });

  group('StreakCalculator.bestStreak', () {
    test('finds the longest historical run, not just the trailing one', () {
      expect(calc.bestStreak([c, c, c, c, m, c, c]), 4);
    });

    test('skipped/pending days do not reset the running count', () {
      expect(calc.bestStreak([c, c, s, c, c, pending]), 4);
    });

    test('a partial resets the running count same as a miss', () {
      expect(calc.bestStreak([c, c, p, c, c, c]), 3);
    });
  });
}
