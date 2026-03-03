
import '../../../domain/entities/transaction.dart';
import '../../models/dashboard_summary_model.dart';
import '../../models/transaction_model.dart';
import '../../models/analytics_data_model.dart';

import '../dtos/transaction_dto.dart';

abstract class HomeRemoteDataSource {
  /// Fetch dashboard summary from API
  Future<DashboardSummaryModel> getDashboardSummary();
  
  /// Fetch transactions from API with filters
  Future<Map<String, dynamic>> getTransactions({
    String? type,
    String? category,
    String? startDate,
    String? endDate,
    int? limit,
    int? page,
  });
  
  /// Get a single transaction by ID
  Future<TransactionModel> getTransactionById(String id);
  
  /// Create a new transaction
  Future<TransactionModel> createTransaction(TransactionDto dto);
  
  /// Update an existing transaction
  Future<TransactionModel> updateTransaction(String id, TransactionDto dto);
  
  /// Delete a transaction
  Future<void> deleteTransaction(String id);
  
  /// Get analytics data
  Future<AnalyticsDataModel> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Keep for backward compatibility or dashboard use
  @Deprecated('Use getTransactions instead')
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10});

  @Deprecated('Use createTransaction instead')
  Future<void> addTransaction(Transaction transaction);
}
