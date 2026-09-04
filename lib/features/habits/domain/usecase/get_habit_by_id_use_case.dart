import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/habit_entity.dart';
import '../repo/habit_repository.dart';

class GetHabitByIdUseCase extends UseCaseWithParams<HabitEntity, String> {
  final HabitRepository _repository;

  const GetHabitByIdUseCase(this._repository);

  @override
  ResultFuture<HabitEntity> call(String habitId) => _repository.getHabitById(habitId);
}
