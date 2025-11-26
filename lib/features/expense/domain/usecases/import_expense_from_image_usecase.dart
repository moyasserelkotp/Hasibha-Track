import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class ImportExpenseFromImageUseCase {
  final ExpenseRepository repository;

  ImportExpenseFromImageUseCase(this.repository);

  Future<Either<Failure, Expense>> call(String imagePath) {
    return repository.importExpenseFromImage(imagePath);
  }
}
