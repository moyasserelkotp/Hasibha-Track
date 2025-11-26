import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

class GetBudgetsUseCase {
  final BudgetRepository repository;

  GetBudgetsUseCase(this.repository);

  Future<Either<Failure, List<Budget>>> call({
    bool? isActive,
    String? categoryId,
  }) {
    return repository.getBudgets(
      isActive: isActive,
      categoryId: categoryId,
    );
  }
}
