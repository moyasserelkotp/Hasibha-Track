

import '../../../../../shared/models/app_settings.dart';
import '../../models/category_model.dart';
import '../../models/transaction_model.dart';

abstract class HomeLocalDataSource {
  // Transactions
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10});
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<TransactionModel>> getTransactionsByCategory(String category);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> clearAllTransactions();
  
  // Categories
  Future<void> addCategory(CategoryModel category);
  Future<List<CategoryModel>> getCategories();
  Future<List<CategoryModel>> getCategoriesByType(String type);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<void> seedDefaultCategories();
  
  // Settings
  Future<void> saveSettings(AppSettings settings);
  Future<AppSettings> getSettings();
}
