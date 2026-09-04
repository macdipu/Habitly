import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_stats.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/archive_habit_use_case.dart';
import 'package:customer/features/habits/domain/usecase/delete_habit_use_case.dart';
import 'package:customer/features/habits/domain/usecase/get_habit_by_id_use_case.dart';
import 'package:customer/features/habits/domain/usecase/get_habit_stats_use_case.dart';
import 'package:get/get.dart';

class HabitDetailController extends BaseController {
  final String habitId;

  final GetHabitByIdUseCase _getHabit;
  final GetHabitStatsUseCase _getStats;
  final ArchiveHabitUseCase _archiveHabit;
  final DeleteHabitUseCase _deleteHabit;

  HabitDetailController(HabitRepository repository, this.habitId)
      : _getHabit = GetHabitByIdUseCase(repository),
        _getStats = GetHabitStatsUseCase(repository),
        _archiveHabit = ArchiveHabitUseCase(repository),
        _deleteHabit = DeleteHabitUseCase(repository);

  final Rx<HabitEntity?> habit = Rx<HabitEntity?>(null);
  final Rx<HabitStats?> stats = Rx<HabitStats?>(null);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    await doAction<HabitEntity>(
      action: () => _getHabit(habitId),
      onSuccess: (result) {
        habit.value = result;
        _loadStats();
      },
    );
  }

  Future<void> _loadStats() async {
    final today = LocalDate.fromDateTime(DateTime.now());
    await doAction<HabitStats>(
      action: () => _getStats(GetHabitStatsParams(
        habitId: habitId,
        from: today.addDays(-89),
        to: today,
      )),
      onSuccess: (result) => stats.value = result,
    );
  }

  Future<bool> archive() async {
    var success = false;
    await doAction<void>(
      action: () => _archiveHabit(habitId),
      onSuccess: (_) => success = true,
    );
    return success;
  }

  Future<bool> delete() async {
    var success = false;
    await doAction<void>(
      action: () => _deleteHabit(habitId),
      onSuccess: (_) => success = true,
    );
    return success;
  }
}
