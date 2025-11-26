import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteExpense(id);
  }
}
