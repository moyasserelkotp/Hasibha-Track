import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  Future<Either<Failure, Expense>> call(Expense expense) {
    return repository.updateExpense(expense);
  }
}
