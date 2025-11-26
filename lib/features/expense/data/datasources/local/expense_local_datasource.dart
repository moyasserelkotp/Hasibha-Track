import 'package:hive/hive.dart';
import '../../models/expense_model.dart';
import '../../models/expense_category_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> cacheExpenses(List<ExpenseModel> expenses);
  Future<List<ExpenseModel>> getCachedExpenses();
  Future<void> cacheExpense(ExpenseModel expense);
  Future<ExpenseModel?> getCachedExpense(String id);
  Future<void> deleteExpenseFromCache(String id);
  Future<void> cacheCategories(List<ExpenseCategoryModel> categories);
  Future<List<ExpenseCategoryModel>> getCachedCategories();
  Future<void> clearExpenseCache();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final Box<Map<dynamic, dynamic>> expenseBox;
  final Box<Map<dynamic, dynamic>> categoryBox;

  ExpenseLocalDataSourceImpl({
    required this.expenseBox,
    required this.categoryBox,
  });

  static const String _expenseKey = 'expenses';
  static const String _categoryKey = 'categories';

  @override
  Future<void> cacheExpenses(List<ExpenseModel> expenses) async {
    final expensesJson = expenses.map((e) => e.toJson()).toList();
    await expenseBox.put(_expenseKey, {'data': expensesJson});
  }

  @override
  Future<List<ExpenseModel>> getCachedExpenses() async {
    final cached = expenseBox.get(_expenseKey);
    if (cached == null) return [];

    final List<dynamic> data = cached['data'] as List<dynamic>;
    return data
        .map((json) => ExpenseModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> cacheExpense(ExpenseModel expense) async {
    final expenses = await getCachedExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    
    if (index != -1) {
      expenses[index] = expense;
    } else {
      expenses.add(expense);
    }
    
    await cacheExpenses(expenses);
  }

  @override
  Future<ExpenseModel?> getCachedExpense(String id) async {
    final expenses = await getCachedExpenses();
    try {
      return expenses.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteExpenseFromCache(String id) async {
    final expenses = await getCachedExpenses();
    expenses.removeWhere((e) => e.id == id);
    await cacheExpenses(expenses);
  }

  @override
  Future<void> cacheCategories(List<ExpenseCategoryModel> categories) async {
    final categoriesJson = categories.map((c) => c.toJson()).toList();
    await categoryBox.put(_categoryKey, {'data': categoriesJson});
  }

  @override
  Future<List<ExpenseCategoryModel>> getCachedCategories() async {
    final cached = categoryBox.get(_categoryKey);
    if (cached == null) return [];

    final List<dynamic> data = cached['data'] as List<dynamic>;
    return data
        .map((json) => ExpenseCategoryModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  @override
  Future<void> clearExpenseCache() async {
    await expenseBox.clear();
    await categoryBox.clear();
  }
}
