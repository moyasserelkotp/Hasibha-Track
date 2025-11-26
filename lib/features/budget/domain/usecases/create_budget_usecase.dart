import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class CreateBudgetUseCase {
  final BudgetRepository repository;

  CreateBudgetUseCase(this.repository);

  Future<Either<Failure, Budget>> call(Budget budget) {
    return repository.createBudget(budget);
  }
}
