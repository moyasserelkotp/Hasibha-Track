import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/budget.dart';

/// Repository contract for budget management
abstract class BudgetRepository {
  /// Get all budgets
  Future<Either<Failure, List<Budget>>> getBudgets({
    bool? isActive,
    String? categoryId,
  });

  /// Get single budget by ID
  Future<Either<Failure, Budget>> getBudgetById(String id);

  /// Create new budget
  Future<Either<Failure, Budget>> createBudget(Budget budget);

  /// Update existing budget
  Future<Either<Failure, Budget>> updateBudget(Budget budget);

  /// Delete budget
  Future<Either<Failure, void>> deleteBudget(String id);

  /// Get budget for specific category and period
  Future<Either<Failure, Budget?>> getBudgetForCategory({
    required String categoryId,
    required BudgetPeriod period,
  });

  /// Update spent amount for a budget
  Future<Either<Failure, Budget>> updateSpentAmount({
    required String budgetId,
    required double amount,
  });

  /// Check if any budget limits are exceeded
  Future<Either<Failure, List<Budget>>> getExceededBudgets();

  /// Get budgets approaching limit (>= threshold%)
  Future<Either<Failure, List<Budget>>> getApproachingLimitBudgets({
    double threshold = 80.0,
  });
}
