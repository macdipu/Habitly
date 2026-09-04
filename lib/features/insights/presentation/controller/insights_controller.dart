import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/entity/habit_insight.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/get_insights_overview_use_case.dart';
import 'package:get/get.dart';

class InsightsController extends BaseController {
  final GetInsightsOverviewUseCase _getOverview;

  InsightsController(HabitRepository repository) : _getOverview = GetInsightsOverviewUseCase(repository);

  final RxList<HabitInsight> insights = <HabitInsight>[].obs;
  final RxInt rangeDays = 30.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    await doAction<List<HabitInsight>>(
      action: () => _getOverview(GetInsightsOverviewParams(rangeDays: rangeDays.value)),
      onSuccess: (result) => insights.assignAll(result),
    );
  }

  void setRange(int days) {
    rangeDays.value = days;
    load();
  }

  int get mostConsistentIndex {
    if (insights.isEmpty) return -1;
    var bestIndex = 0;
    for (var i = 1; i < insights.length; i++) {
      final best = insights[bestIndex].stats.adherencePercent ?? -1;
      final candidate = insights[i].stats.adherencePercent ?? -1;
      if (candidate > best) bestIndex = i;
    }
    return bestIndex;
  }
}
