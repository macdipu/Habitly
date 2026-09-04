import 'dart:io';

import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Flattened, human-readable check-in history export (BRD §14.2). Dates
/// and units are unambiguous: ISO-8601 local dates, and the habit's own
/// unit string alongside every value.
class CsvExportService {
  final HabitRepository _repository;

  const CsvExportService(this._repository);

  Future<Either<Failure, File>> exportCheckIns() async {
    Failure? failure;

    final activeResult = await _repository.getActiveHabits();
    final archivedResult = await _repository.getArchivedHabits();
    final active = activeResult.fold((l) {
      failure = l;
      return <HabitEntity>[];
    }, (r) => r);
    final archived = archivedResult.fold((l) {
      failure = l;
      return <HabitEntity>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final habits = [...active, ...archived];
    final rows = <List<String>>[
      ['Habit', 'Date', 'Status', 'Value', 'Unit', 'Note'],
    ];

    for (final habit in habits) {
      final checkInsResult = await _repository.getCheckIns(
        habitId: habit.id,
        from: const LocalDate(1970, 1, 1),
        to: LocalDate.fromDateTime(DateTime.now()).addDays(3650),
      );
      checkInsResult.fold((l) => failure = l, (checkIns) {
        for (final checkIn in checkIns) {
          rows.add([
            habit.name,
            checkIn.localDate.toString(),
            checkIn.status.name,
            checkIn.value?.toString() ?? '',
            habit.unit ?? '',
            checkIn.note ?? '',
          ]);
        }
      });
    }
    if (failure != null) return Left(failure!);

    try {
      final csv = rows.map((row) => row.map(csvCell).join(',')).join('\r\n');
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'habitly_checkins_${DateTime.now().toUtc().millisecondsSinceEpoch}.csv';
      final file = File(p.join(dir.path, fileName));
      await file.writeAsString(csv);
      return Right(file);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure('Failed to write CSV file: $e'));
    }
  }

  static String csvCell(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
