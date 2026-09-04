import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026);

  HabitEntity countHabit() => HabitEntity(
        id: 'h1',
        name: 'Drink water',
        type: HabitType.count,
        icon: 'water_drop',
        color: 0xFF000000,
        description: 'Stay hydrated',
        unit: 'glasses',
        target: 8,
        goalDirection: GoalDirection.atLeast,
        createdAt: now,
        updatedAt: now,
      );

  group('HabitEntity.copyWith', () {
    test('omitting a nullable field leaves it unchanged', () {
      final result = countHabit().copyWith(name: 'Drink more water');
      expect(result.unit, 'glasses');
      expect(result.target, 8);
      expect(result.description, 'Stay hydrated');
    });

    test('clearX flags actually null out the field — this is the whole point of copyWith '
        'having them; without it, editing a habit from Count to Binary would silently '
        'keep the stale unit/target forever (a real bug caught while building Edit Habit)', () {
      final result = countHabit().copyWith(
        type: HabitType.binary,
        clearUnit: true,
        clearTarget: true,
      );
      expect(result.type, HabitType.binary);
      expect(result.unit, isNull);
      expect(result.target, isNull);
    });

    test('clearDescription empties the description', () {
      final result = countHabit().copyWith(clearDescription: true);
      expect(result.description, isNull);
    });

    test('type is actually changeable via copyWith', () {
      final result = countHabit().copyWith(type: HabitType.duration);
      expect(result.type, HabitType.duration);
    });

    test('passing a value alongside its clear flag still clears (clear wins)', () {
      final result = countHabit().copyWith(unit: 'minutes', clearUnit: true);
      expect(result.unit, isNull);
    });
  });
}
