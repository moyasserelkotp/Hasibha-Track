import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/savings_goal.dart';

abstract class SavingsRepository {
  Future<Either<Failure, List<SavingsGoal>>> getSavingsGoals();
  Future<Either<Failure, SavingsGoal>> getSavingsGoalById(String id);
  Future<Either<Failure, SavingsGoal>> createSavingsGoal(SavingsGoal goal);
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(SavingsGoal goal);
  Future<Either<Failure, void>> deleteSavingsGoal(String id);
  Future<Either<Failure, SavingsGoal>> addFunds(String id, double amount);
  Future<Either<Failure, SavingsGoal>> withdrawFunds(String id, double amount);
}
