import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/entity/today_habit_item.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/get_today_habits_use_case.dart';
import 'package:customer/features/habits/domain/usecase/save_check_in_use_case.dart';
import 'package:customer/features/habits/domain/usecase/undo_check_in_use_case.dart';
import 'package:get/get.dart';

class TodayController extends BaseController {
  final GetTodayHabitsUseCase _getTodayHabits;
  final SaveCheckInUseCase _saveCheckIn;
  final UndoCheckInUseCase _undoCheckIn;

  TodayController(HabitRepository repository)
      : _getTodayHabits = GetTodayHabitsUseCase(repository),
        _saveCheckIn = SaveCheckInUseCase(repository),
        _undoCheckIn = UndoCheckInUseCase(repository);

  final RxList<TodayHabitItem> items = <TodayHabitItem>[].obs;

  LocalDate get today => LocalDate.fromDateTime(DateTime.now());

  List<TodayHabitItem> get dueNow => items.where((i) => !i.isDone).toList();
  List<TodayHabitItem> get completed => items.where((i) => i.isDone).toList();

  @override
  void onInit() {
    super.onInit();
    loadToday();
  }

  Future<void> loadToday() async {
    await doAction<List<TodayHabitItem>>(
      action: () => _getTodayHabits(today),
      onSuccess: (result) => items.assignAll(result),
    );
  }

  /// Single-tap completion for binary habits; count/duration habits pass
  /// their logged [value] from the quick check-in sheet (S06).
  Future<void> checkIn(TodayHabitItem item, {double? value}) async {
    await doAction<void>(
      action: () => _saveCheckIn(SaveCheckInParams(habit: item.habit, date: today, value: value)),
      onSuccess: (_) => loadToday(),
    );
  }

  Future<void> skipToday(TodayHabitItem item) async {
    await doAction<void>(
      action: () => _saveCheckIn(SaveCheckInParams(habit: item.habit, date: today, skip: true)),
      onSuccess: (_) => loadToday(),
    );
  }

  Future<void> undo(TodayHabitItem item) async {
    await doAction<void>(
      action: () => _undoCheckIn(UndoCheckInParams(habitId: item.habit.id, date: today)),
      onSuccess: (_) => loadToday(),
    );
  }

  bool needsQuickEntry(TodayHabitItem item) =>
      item.habit.type == HabitType.count || item.habit.type == HabitType.duration;
}
