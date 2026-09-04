import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/entity/today_habit_item.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/get_day_habits_use_case.dart';
import 'package:customer/features/habits/domain/usecase/save_check_in_use_case.dart';
import 'package:customer/features/habits/domain/usecase/undo_check_in_use_case.dart';
import 'package:get/get.dart';

/// S15 — explains exactly what happened on one date, and supports
/// add/edit/remove of historical check-ins (docs/SRS.md FR-41). "Today" for
/// pending/missed resolution always comes from the real clock, never from
/// [date] — see [GetDayHabitsUseCase].
class DayDetailController extends BaseController {
  final LocalDate date;

  final GetDayHabitsUseCase _getDayHabits;
  final SaveCheckInUseCase _saveCheckIn;
  final UndoCheckInUseCase _undoCheckIn;

  DayDetailController(HabitRepository repository, this.date)
      : _getDayHabits = GetDayHabitsUseCase(repository),
        _saveCheckIn = SaveCheckInUseCase(repository),
        _undoCheckIn = UndoCheckInUseCase(repository);

  final RxList<TodayHabitItem> items = <TodayHabitItem>[].obs;

  /// Whether any check-in/undo happened — the caller (Calendar) uses this
  /// to decide whether to reload the month grid on return.
  final RxBool changed = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    await doAction<List<TodayHabitItem>>(
      action: () => _getDayHabits(date),
      onSuccess: (result) => items.assignAll(result),
    );
  }

  Future<void> checkIn(TodayHabitItem item, {double? value}) async {
    await doAction<void>(
      action: () => _saveCheckIn(SaveCheckInParams(habit: item.habit, date: date, value: value)),
      onSuccess: (_) {
        changed.value = true;
        load();
      },
    );
  }

  Future<void> skip(TodayHabitItem item) async {
    await doAction<void>(
      action: () => _saveCheckIn(SaveCheckInParams(habit: item.habit, date: date, skip: true)),
      onSuccess: (_) {
        changed.value = true;
        load();
      },
    );
  }

  Future<void> undo(TodayHabitItem item) async {
    await doAction<void>(
      action: () => _undoCheckIn(UndoCheckInParams(habitId: item.habit.id, date: date)),
      onSuccess: (_) {
        changed.value = true;
        load();
      },
    );
  }
}
