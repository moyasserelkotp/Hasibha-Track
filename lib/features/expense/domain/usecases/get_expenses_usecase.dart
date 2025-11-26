import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repository;

  GetExpensesUseCase(this.repository);

  Future<Either<Failure, List<Expense>>> call({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    List<String>? tags,
    int? limit,
    int? offset,
  }) {
    return repository.getExpenses(
      startDate: startDate,
      endDate: endDate,
      categoryId: categoryId,
      tags: tags,
      limit: limit,
      offset: offset,
    );
  }
}
