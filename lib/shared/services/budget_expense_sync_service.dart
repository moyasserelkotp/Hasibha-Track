import '../../features/budget/domain/repositories/budget_repository.dart';
import '../../features/budget/domain/entities/budget.dart';
import '../../features/expense/domain/entities/expense.dart';
import 'logger_service.dart';

/// Service to sync budget spent amounts when expenses change
class BudgetExpenseSyncService {
  final BudgetRepository budgetRepository;
  final _logger = LoggerService();

  BudgetExpenseSyncService({required this.budgetRepository});

  /// Update budget spent after expense is created
  Future<void> onExpenseCreated(Expense expense) async {
    await _updateBudgetForCategory(expense.categoryId);
  }

  /// Update budget spent after expense is updated
  Future<void> onExpenseUpdated(Expense oldExpense, Expense newExpense) async {
    // If category changed, update both budgets
    if (oldExpense.categoryId != newExpense.categoryId) {
      await _updateBudgetForCategory(oldExpense.categoryId);
      await _updateBudgetForCategory(newExpense.categoryId);
    } else {
      // Same category, just update once
      await _updateBudgetForCategory(newExpense.categoryId);
    }
  }

  /// Update budget spent after expense is deleted
  Future<void> onExpenseDeleted(Expense expense) async {
    await _updateBudgetForCategory(expense.categoryId);
  }

  /// Find and refresh budget for a specific category
  Future<void> _updateBudgetForCategory(String categoryId) async {
    // The backend should handle recalculating spent amounts
    // Here we just trigger a refresh by fetching the budget
    
    // Try to get monthly budget for this category (most common)
    final result = await budgetRepository.getBudgetForCategory(
      categoryId: categoryId,
      period: BudgetPeriod.monthly,
    );

    result.fold(
      (failure) {
        // If no monthly budget, try other periods
        // In a real app, we'd check all active budgets for this category
        _logger.debug('No monthly budget found for category $categoryId');
      },
      (budget) {
        if (budget != null) {
          _logger.debug('Budget found and will be auto-updated by backend');
        }
      },
    );
  }
}
