import 'package:customer/core/domain/habit/adherence_calculator.dart';
import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calc = AdherenceCalculator();

  group('AdherenceCalculator', () {
    test('returns null ("not enough data") when there are no eligible occurrences', () {
      expect(calc.adherencePercent([]), isNull);
      expect(
        calc.adherencePercent([OccurrenceState.notScheduled, OccurrenceState.pending]),
        isNull,
      );
    });

    test('skipped occurrences are excluded from both numerator and denominator', () {
      final percent = calc.adherencePercent([
        OccurrenceState.completed,
        OccurrenceState.completed,
        OccurrenceState.skipped,
        OccurrenceState.skipped,
        OccurrenceState.skipped,
      ]);
      expect(percent, 100.0);
    });

    test('partial and missed both count against adherence', () {
      final percent = calc.adherencePercent([
        OccurrenceState.completed,
        OccurrenceState.partial,
        OccurrenceState.missed,
        OccurrenceState.completed,
      ]);
      expect(percent, 50.0);
    });

    test('pending occurrences are excluded (not yet resolved)', () {
      final percent = calc.adherencePercent([
        OccurrenceState.completed,
        OccurrenceState.missed,
        OccurrenceState.pending,
      ]);
      expect(percent, 50.0);
    });
  });
}
