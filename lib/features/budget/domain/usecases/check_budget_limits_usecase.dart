import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class CheckBudgetLimitsUseCase {
  final BudgetRepository repository;

  CheckBudgetLimitsUseCase(this.repository);

  /// Check for exceeded budgets
  Future<Either<Failure, List<Budget>>> callExceeded() {
    return repository.getExceededBudgets();
  }

  /// Check for budgets approaching limit
  Future<Either<Failure, List<Budget>>> callApproaching({
    double threshold = 80.0,
  }) {
    return repository.getApproachingLimitBudgets(threshold: threshold);
  }
}
