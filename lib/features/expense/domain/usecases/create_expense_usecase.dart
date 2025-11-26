import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class CreateExpenseUseCase {
  final ExpenseRepository repository;

  CreateExpenseUseCase(this.repository);

  Future<Either<Failure, Expense>> call(Expense expense) {
    return repository.createExpense(expense);
  }
}
