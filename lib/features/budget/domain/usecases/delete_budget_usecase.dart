import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/budget_repository.dart';

class DeleteBudgetUseCase {
  final BudgetRepository repository;

  DeleteBudgetUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteBudget(id);
  }
}
