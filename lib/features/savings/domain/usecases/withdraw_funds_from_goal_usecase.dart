import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/savings_goal.dart';
import '../repositories/savings_repository.dart';

class WithdrawFundsFromGoalUseCase {
  final SavingsRepository repository;

  WithdrawFundsFromGoalUseCase(this.repository);

  Future<Either<Failure, SavingsGoal>> call(String id, double amount) {
    return repository.withdrawFunds(id, amount);
  }
}
