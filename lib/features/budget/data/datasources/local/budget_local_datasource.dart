import 'package:hive/hive.dart';
import '../../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<void> cacheBudgets(List<BudgetModel> budgets);
  Future<List<BudgetModel>> getCachedBudgets();
  Future<void> cacheBudget(BudgetModel budget);
  Future<BudgetModel?> getCachedBudget(String id);
  Future<void> deleteBudgetFromCache(String id);
  Future<void> clearBudgetCache();
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final Box<Map<dynamic, dynamic>> budgetBox;

  BudgetLocalDataSourceImpl({required this.budgetBox});

  static const String _budgetKey = 'budgets';

  @override
  Future<void> cacheBudgets(List<BudgetModel> budgets) async {
    final budgetsJson = budgets.map((b) => b.toJson()).toList();
    await budgetBox.put(_budgetKey, {'data': budgetsJson});
  }

  @override
  Future<List<BudgetModel>> getCachedBudgets() async {
    final cached = budgetBox.get(_budgetKey);
    if (cached == null) return [];

    final List<dynamic> data = cached['data'] as List<dynamic>;
    return data
        .map((json) => BudgetModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> cacheBudget(BudgetModel budget) async {
    final budgets = await getCachedBudgets();
    final index = budgets.indexWhere((b) => b.id == budget.id);
    
    if (index != -1) {
      budgets[index] = budget;
    } else {
      budgets.add(budget);
    }
    
    await cacheBudgets(budgets);
  }

  @override
  Future<BudgetModel?> getCachedBudget(String id) async {
    final budgets = await getCachedBudgets();
    try {
      return budgets.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteBudgetFromCache(String id) async {
    final budgets = await getCachedBudgets();
    budgets.removeWhere((b) => b.id == id);
    await cacheBudgets(budgets);
  }

  @override
  Future<void> clearBudgetCache() async {
    await budgetBox.clear();
  }
}
