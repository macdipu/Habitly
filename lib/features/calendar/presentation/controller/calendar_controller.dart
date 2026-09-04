import 'package:customer/core/domain/habit/calendar_day_aggregator.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/get_month_calendar_use_case.dart';
import 'package:get/get.dart';

class CalendarController extends BaseController {
  final GetMonthCalendarUseCase _getMonth;

  CalendarController(HabitRepository repository) : _getMonth = GetMonthCalendarUseCase(repository);

  final now = DateTime.now();
  late final Rx<int> visibleYear = now.year.obs;
  late final Rx<int> visibleMonth = now.month.obs;

  final RxMap<LocalDate, CalendarDayStatus> statuses = <LocalDate, CalendarDayStatus>{}.obs;
  final Rx<LocalDate?> selectedDate = Rx<LocalDate?>(null);

  @override
  void onInit() {
    super.onInit();
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
