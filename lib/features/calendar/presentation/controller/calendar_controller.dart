import 'package:customer/core/domain/habit/calendar_day_aggregator.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/get_month_calendar_use_case.dart';
import 'package:get/get.dart';

class CalendarController extends BaseController {
  final GetMonthCalendarUseCase _getMonth;
  final AppSettingsRepository _settingsRepository;

  CalendarController(HabitRepository repository, this._settingsRepository)
      : _getMonth = GetMonthCalendarUseCase(repository);

  final now = DateTime.now();
  late final Rx<int> visibleYear = now.year.obs;
  late final Rx<int> visibleMonth = now.month.obs;

  final RxMap<LocalDate, CalendarDayStatus> statuses = <LocalDate, CalendarDayStatus>{}.obs;
  final Rx<LocalDate?> selectedDate = Rx<LocalDate?>(null);

  /// ISO weekday the grid's first column is (BRD §S03/§16 "locale-aware
  /// first day of week"). Defaults to Monday until loaded.
  final RxInt startOfWeekIsoDay = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _settingsRepository.getStartOfWeek().then((v) => startOfWeekIsoDay.value = v);
    load();
  }

  Future<void> load() async {
    await doAction<Map<LocalDate, CalendarDayStatus>>(
      action: () => _getMonth(GetMonthCalendarParams(year: visibleYear.value, month: visibleMonth.value)),
      onSuccess: (result) => statuses.assignAll(result),
    );
  }

  void nextMonth() {
    if (visibleMonth.value == 12) {
      visibleMonth.value = 1;
      visibleYear.value++;
    } else {
      visibleMonth.value++;
    }
    load();
  }

  void previousMonth() {
    if (visibleMonth.value == 1) {
      visibleMonth.value = 12;
      visibleYear.value--;
    } else {
      visibleMonth.value--;
    }
    load();
  }

  int get successDayCount =>
      statuses.values.where((s) => s == CalendarDayStatus.success).length;

  int get trackedDayCount =>
      statuses.values.where((s) => s != CalendarDayStatus.none).length;
}
