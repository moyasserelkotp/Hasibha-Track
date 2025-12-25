import 'dart:async';
import 'package:hasibha/shared/core/error/exceptions.dart';
import '../../models/expense_model.dart';
import '../../models/expense_category_model.dart';
import '../../dtos/expense_dto.dart';
import 'expense_remote_datasource.dart';

class MockExpenseRemoteDataSource implements ExpenseRemoteDataSource {
  final List<ExpenseModel> _expenses = [];
  final List<ExpenseCategoryModel> _categories = [
    ExpenseCategoryModel(
      id: '1', 
      name: 'Food', 
      iconName: 'fastfood', 
      colorHex: '#FF5733', 
      type: 'expense',
      createdAt: DateTime.now(),
    ),
    ExpenseCategoryModel(
      id: '2', 
      name: 'Transport', 
      iconName: 'directions_car', 
      colorHex: '#33C1FF', 
      type: 'expense',
      createdAt: DateTime.now(),
    ),
    ExpenseCategoryModel(
      id: '3', 
      name: 'Shopping', 
      iconName: 'shopping_bag', 
      colorHex: '#FF33A8', 
      type: 'expense',
      createdAt: DateTime.now(),
    ),
    ExpenseCategoryModel(
      id: '4', 
      name: 'Bills', 
      iconName: 'receipt', 
      colorHex: '#33FF57', 
      type: 'expense',
      createdAt: DateTime.now(),
    ),
    ExpenseCategoryModel(
      id: '5', 
      name: 'Entertainment', 
      iconName: 'movie', 
      colorHex: '#A833FF', 
      type: 'expense',
      createdAt: DateTime.now(),
    ),
  ];

  MockExpenseRemoteDataSource() {
    // Initialize with some dummy expenses
    _expenses.addAll([
      ExpenseModel(
        id: '1',
        amount: 25.50,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        categoryId: '1',
        description: 'Lunch at Subway',
        tags: ['lunch', 'work'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ExpenseModel(
        id: '2',
        amount: 15.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        categoryId: '2',
        description: 'Uber ride',
        tags: ['transport'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ExpenseModel(
        id: '3',
        amount: 120.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        categoryId: '3',
        description: 'Groceries',
        tags: ['groceries', 'home'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ExpenseModel(
        id: '4',
        amount: 45.00,
        date: DateTime.now().subtract(const Duration(days: 3)),
        categoryId: '5',
        description: 'Movie night',
        tags: ['fun'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ]);
  }

  @override
  Future<List<ExpenseModel>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    String? categoryId,
    List<String>? tags,
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    var filtered = _expenses;

    if (startDate != null) {
      filtered = filtered.where((e) => e.date.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      filtered = filtered.where((e) => e.date.isBefore(endDate)).toList();
    }
    if (categoryId != null) {
      filtered = filtered.where((e) => e.categoryId == categoryId).toList();
    }

    if (offset != null) {
      filtered = filtered.skip(offset).toList();
    }
    if (limit != null) {
      filtered = filtered.take(limit).toList();
    }

    return filtered;
  }

  @override
  Future<ExpenseModel> getExpenseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _expenses.firstWhere((e) => e.id == id);
    } catch (e) {
      throw ServerException(message: 'Expense not found');
    }
  }

  @override
  Future<ExpenseModel> createExpense(ExpenseDto dto) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final newExpense = ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: dto.amount,
      date: DateTime.parse(dto.date),
      categoryId: dto.categoryId,
      description: dto.description,
      tags: dto.tags,
      // receiptUrl: dto.receiptUrl, // Not supported in model
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _expenses.add(newExpense);
    return newExpense;
  }

  @override
  Future<ExpenseModel> updateExpense(String id, ExpenseDto dto) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) throw ServerException(message: 'Expense not found');

    final updatedExpense = ExpenseModel(
      id: id,
      amount: dto.amount,
      date: DateTime.parse(dto.date),
      categoryId: dto.categoryId,
      description: dto.description,
      tags: dto.tags,
      // receiptUrl: dto.receiptUrl,
      createdAt: _expenses[index].createdAt, // Keep original createdAt
      updatedAt: DateTime.now(),
    );
    _expenses[index] = updatedExpense;
    return updatedExpense;
  }

  @override
  Future<void> deleteExpense(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _expenses.removeWhere((e) => e.id == id);
  }

  @override
  Future<List<ExpenseCategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _categories;
  }

  @override
  Future<ExpenseCategoryModel> createCategory(Map<String, dynamic> categoryData) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newCategory = ExpenseCategoryModel.fromJson({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      ...categoryData,
      'created_at': DateTime.now().toIso8601String(),
    });
    _categories.add(newCategory);
    return newCategory;
  }

  @override
  Future<Map<String, double>> getSpendingByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final Map<String, double> spending = {};
    
    for (var expense in _expenses) {
      if (expense.date.isAfter(startDate) && expense.date.isBefore(endDate)) {
        // Resolve category name
        final category = _categories.firstWhere(
          (c) => c.id == expense.categoryId,
          orElse: () => _categories.first,
        );
        spending[category.name] = (spending[category.name] ?? 0) + expense.amount;
      }
    }
    
    return spending;
  }
}
