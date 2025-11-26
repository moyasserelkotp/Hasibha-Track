import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/expense.dart';
import '../entities/expense_category.dart';

/// Repository contract for expense management
abstract class ExpenseRepository {
  /// Get all expenses with optional filters
  Future<Either<Failure, List<Expense>>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    List<String>? tags,
    int? limit,
    int? offset,
  });

  /// Get single expense by ID
  Future<Either<Failure, Expense>> getExpenseById(String id);

  /// Create new expense
  Future<Either<Failure, Expense>> createExpense(Expense expense);

  /// Update existing expense
  Future<Either<Failure, Expense>> updateExpense(Expense expense);

  /// Delete expense
  Future<Either<Failure, void>> deleteExpense(String id);

  /// Get all categories
  Future<Either<Failure, List<ExpenseCategory>>> getCategories();

  /// Create new category
  Future<Either<Failure, ExpenseCategory>> createCategory(
      ExpenseCategory category);

  /// Update category
  Future<Either<Failure, ExpenseCategory>> updateCategory(
      ExpenseCategory category);

  /// Delete category
  Future<Either<Failure, void>> deleteCategory(String id);

  /// Get total spending by category for a period
  Future<Either<Failure, Map<String, double>>> getSpendingByCategory({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Import expense from image (OCR)
  Future<Either<Failure, Expense>> importExpenseFromImage(String imagePath);
}
