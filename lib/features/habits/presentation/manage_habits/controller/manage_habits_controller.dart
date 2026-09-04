import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/restore_habit_use_case.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:get/get.dart';

/// S18 (search/filter) + S19 (archived habits) condensed into one screen —
/// a small habit list doesn't need two separate destinations, and this
/// keeps restore reachable without duplicating Habit Detail's
/// archive/delete affordances (that split is intentional, see
/// EditHabitScreen's doc comment).
class ManageHabitsController extends BaseController {
  final HabitRepository _repository;
  final RestoreHabitUseCase _restoreHabit;
  final ReminderReconciler _reminderReconciler;

  ManageHabitsController(this._repository, this._reminderReconciler)
      : _restoreHabit = RestoreHabitUseCase(_repository);

  final RxList<HabitEntity> activeHabits = <HabitEntity>[].obs;
  final RxList<HabitEntity> archivedHabits = <HabitEntity>[].obs;
  final RxString query = ''.obs;
  final RxBool showArchived = false.obs;

  List<HabitEntity> get _sourceList => showArchived.value ? archivedHabits : activeHabits;

  List<HabitEntity> get visibleHabits {
    final q = query.value.trim().toLowerCase();
    if (q.isEmpty) return _sourceList;
    return _sourceList.where((h) => h.name.toLowerCase().contains(q)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    await doAction<List<HabitEntity>>(
      action: _repository.getActiveHabits,
      onSuccess: (result) => activeHabits.assignAll(result),
    );
    await doAction<List<HabitEntity>>(
      action: _repository.getArchivedHabits,
      onSuccess: (result) => archivedHabits.assignAll(result),
    );
  }

  Future<void> restore(String habitId) async {
    await doAction<void>(
      action: () => _restoreHabit(habitId),
      onSuccess: (_) async {
        await load();
        // Mirrors HabitDetailController.archive()'s symmetric call —
        // reconcile picks the now-active habit back up for scheduling.
        await _reminderReconciler.reconcileHabit(habitId);
      },
    );
  }
}
