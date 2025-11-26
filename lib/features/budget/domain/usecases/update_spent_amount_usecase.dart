import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class UpdateSpentAmountUseCase {
  final BudgetRepository repository;

  UpdateSpentAmountUseCase(this.repository);

  Future<Either<Failure, Budget>> call({
    required String budgetId,
    required double amount,
  }) {
    return repository.updateSpentAmount(
      budgetId: budgetId,
      amount: amount,
    );
  }
}
