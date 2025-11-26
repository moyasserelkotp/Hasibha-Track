import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/savings_goal.dart';
import '../repositories/savings_repository.dart';

class CreateSavingsGoalUseCase {
  final SavingsRepository repository;

  CreateSavingsGoalUseCase(this.repository);

  Future<Either<Failure, SavingsGoal>> call(SavingsGoal goal) {
    return repository.createSavingsGoal(goal);
  }
}
