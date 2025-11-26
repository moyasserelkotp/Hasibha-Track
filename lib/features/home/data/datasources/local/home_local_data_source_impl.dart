import 'package:hive/hive.dart';

import '../../../../../shared/local/boxes/box_names.dart';
import '../../../../../shared/models/app_settings.dart';
import '../../models/category_model.dart';
import '../../models/default_categories.dart';
import '../../models/transaction_model.dart';
import 'home_local_data_source.dart';

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  // Transaction CRUD
  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final box = Hive.box(BoxNames.transactions);
    await box.put(transaction.id, transaction);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final box = Hive.box(BoxNames.transactions);
    return box.values.cast<TransactionModel>().toList();
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10}) async {
    final transactions = await getTransactions();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(limit).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final transactions = await getTransactions();
    return transactions.where((t) {
      return t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          t.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(String category) async {
    final transactions = await getTransactions();
    return transactions.where((t) => t.category == category).toList();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final box = Hive.box(BoxNames.transactions);
    await box.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final box = Hive.box(BoxNames.transactions);
    await box.delete(id);
  }

  @override
  Future<void> clearAllTransactions() async {
    final box = Hive.box(BoxNames.transactions);
    await box.clear();
  }

  // Category CRUD
  @override
  Future<void> addCategory(CategoryModel category) async {
    final box = Hive.box(BoxNames.categories);
    await box.put(category.id, category);
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final box = Hive.box(BoxNames.categories);
    final categories = box.values.cast<CategoryModel>().toList();
    
    // If empty, seed default categories
    if (categories.isEmpty) {
      await seedDefaultCategories();
      return box.values.cast<CategoryModel>().toList();
    }
    
    // Sort by sortOrder
    categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return categories;
  }

  @override
  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    final categories = await getCategories();
    return categories.where((c) => c.type == type).toList();
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final box = Hive.box(BoxNames.categories);
    await box.put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final box = Hive.box(BoxNames.categories);
    final category = box.get(id) as CategoryModel?;
    
    // Don't allow deleting default categories
    if (category != null && !category.isDefault) {
      await box.delete(id);
    }
  }

  @override
  Future<void> seedDefaultCategories() async {
    final box = Hive.box(BoxNames.categories);
    for (final category in DefaultCategories.all) {
      await box.put(category.id, category);
    }
  }

  // Settings
  @override
  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box(BoxNames.settings);
    await box.put('app_settings', settings);
  }

  @override
  Future<AppSettings> getSettings() async {
    final box = Hive.box(BoxNames.settings);
    final settings = box.get('app_settings');
    return settings ?? AppSettings();
  }
}
