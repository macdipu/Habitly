import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_success_rule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HabitSuccessRule', () {
    test('binary: any positive logged value completes, else missed', () {
      const rule = HabitSuccessRule(type: HabitType.binary);
      expect(rule.evaluate(1), CheckInStatus.completed);
      expect(rule.evaluate(null), CheckInStatus.missed);
      expect(rule.evaluate(0), CheckInStatus.missed);
    });

    test('count: below target is partial, at/above target is completed', () {
      const rule = HabitSuccessRule(type: HabitType.count, target: 8);
      expect(rule.evaluate(3), CheckInStatus.partial);
      expect(rule.evaluate(8), CheckInStatus.completed);
      expect(rule.evaluate(10), CheckInStatus.completed);
      expect(rule.evaluate(0), CheckInStatus.missed);
      expect(rule.evaluate(null), CheckInStatus.missed);
    });

    test('duration: same threshold semantics as count', () {
      const rule = HabitSuccessRule(type: HabitType.duration, target: 20);
      expect(rule.evaluate(10), CheckInStatus.partial);
      expect(rule.evaluate(20), CheckInStatus.completed);
    });

    test('count/duration with no target: any logged value completes', () {
      const rule = HabitSuccessRule(type: HabitType.count, target: null);
      expect(rule.evaluate(1), CheckInStatus.completed);
      expect(rule.evaluate(0), CheckInStatus.missed);
    });

    test('avoid: at/below threshold completes, above threshold misses', () {
      const rule = HabitSuccessRule(type: HabitType.avoid, target: 0);
      expect(rule.evaluate(null), CheckInStatus.completed);
      expect(rule.evaluate(0), CheckInStatus.completed);
      expect(rule.evaluate(1), CheckInStatus.missed);
    });

    test('avoid with a nonzero max threshold', () {
      const rule = HabitSuccessRule(type: HabitType.avoid, target: 2);
      expect(rule.evaluate(2), CheckInStatus.completed);
      expect(rule.evaluate(3), CheckInStatus.missed);
    });
  });
}
