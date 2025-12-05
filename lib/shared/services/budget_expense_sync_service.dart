import '../../features/budget/domain/repositories/budget_repository.dart';
import '../../features/budget/domain/entities/budget.dart';
import '../../features/expense/domain/entities/expense.dart';
import 'logger_service.dart';

/// Service to sync budget spent amounts when expenses change
class BudgetExpenseSyncService {
  final BudgetRepository budgetRepository;
  final _logger = Logger.get("BudgetExpenseSyncService");

  BudgetExpenseSyncService({required this.budgetRepository});

  Future<void> onExpenseCreated(Expense expense) async {
    await _updateBudgetForCategory(expense.categoryId);
  }

  Future<void> onExpenseUpdated(Expense oldExpense, Expense newExpense) async {
    if (oldExpense.categoryId != newExpense.categoryId) {
      await _updateBudgetForCategory(oldExpense.categoryId);
      await _updateBudgetForCategory(newExpense.categoryId);
    } else {
      await _updateBudgetForCategory(newExpense.categoryId);
    }
  }

  Future<void> onExpenseDeleted(Expense expense) async {
    await _updateBudgetForCategory(expense.categoryId);
  }

  Future<void> _updateBudgetForCategory(String categoryId) async {
    final result = await budgetRepository.getBudgetForCategory(
      categoryId: categoryId,
      period: BudgetPeriod.monthly,
    );

    result.fold(
          (failure) {
        _logger.debug('No monthly budget found for category $categoryId');
      },
          (budget) {
        if (budget != null) {
          _logger.info('Budget found; backend will update spent amount.');
        }
      },
    );
  }
}
