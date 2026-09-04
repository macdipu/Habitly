import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_stats.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/archive_habit_use_case.dart';
import 'package:customer/features/habits/domain/usecase/delete_habit_use_case.dart';
import 'package:customer/features/habits/domain/usecase/get_habit_by_id_use_case.dart';
import 'package:customer/features/habits/domain/usecase/get_habit_stats_use_case.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:get/get.dart';

class HabitDetailController extends BaseController {
  final String habitId;

  final GetHabitByIdUseCase _getHabit;
  final GetHabitStatsUseCase _getStats;
  final ArchiveHabitUseCase _archiveHabit;
  final DeleteHabitUseCase _deleteHabit;
  final ReminderReconciler _reminderReconciler;

  HabitDetailController(HabitRepository repository, this._reminderReconciler, this.habitId)
      : _getHabit = GetHabitByIdUseCase(repository),
        _getStats = GetHabitStatsUseCase(repository),
        _archiveHabit = ArchiveHabitUseCase(repository),
        _deleteHabit = DeleteHabitUseCase(repository);

  final Rx<HabitEntity?> habit = Rx<HabitEntity?>(null);
  final Rx<HabitStats?> stats = Rx<HabitStats?>(null);

  /// True once an edit succeeded this visit — the screen returns this on
  /// pop (even a plain back-navigation, not just archive/delete) so a
  /// caller like Today/Insights knows to reload rather than show a stale
  /// name/schedule (docs/SRS.md FR-13 correctness, not just archive/delete).
  final RxBool changed = false.obs;

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
    // Archiving cancels future reminders while preserving history (BRD
    // Core Rule "Archive") — reconcile sees the now-archived habit and
    // cancels without rescheduling.
    if (success) await _reminderReconciler.reconcileHabit(habitId);
    return success;
  }

  Future<bool> delete() async {
    // Cancel while the habit's reminders are still readable, before the
    // rows are gone (docs/SRS.md FR-51).
    await _reminderReconciler.cancelHabit(habitId);
    var success = false;
    await doAction<void>(
      action: () => _deleteHabit(habitId),
      onSuccess: (_) => success = true,
    );
    return success;
  }
}
