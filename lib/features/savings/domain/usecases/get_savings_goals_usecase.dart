import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/savings_goal.dart';
import '../repositories/savings_repository.dart';

class GetSavingsGoalsUseCase {
  final SavingsRepository repository;

  GetSavingsGoalsUseCase(this.repository);

  Future<Either<Failure, List<SavingsGoal>>> call() {
    return repository.getSavingsGoals();
  }
}
