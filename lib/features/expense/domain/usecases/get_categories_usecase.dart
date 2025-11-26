import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/expense_category.dart';
import '../repositories/expense_repository.dart';

class GetCategoriesUseCase {
  final ExpenseRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<ExpenseCategory>>> call() {
    return repository.getCategories();
  }
}
