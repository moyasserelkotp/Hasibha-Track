import 'package:dartz/dartz.dart';

import '../../../../shared/core/failure.dart';
import '../entities/dashboard_summary.dart';
import '../entities/transaction.dart';
import '../entities/analytics_data.dart';


abstract class HomeRepository {
  /// Get dashboard summary with financial overview
  Future<Either<Failure, DashboardSummary>> getDashboardSummary();
  
  /// Get transactions with filters and pagination
  Future<Either<Failure, Map<String, dynamic>>> getTransactions({
    String? type,
    String? category,
    String? startDate,
    String? endDate,
    int? limit,
    int? page,
  });
  
  /// Get a single transaction by ID
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  
  /// Create a new transaction
  Future<Either<Failure, Transaction>> createTransaction({
    required String type,
    required double amount,
    required String category,
    String? description,
    String? date,
    String? paymentMethod,
    List<String>? tags,
    String? notes,
  });
  
  /// Update an existing transaction
  Future<Either<Failure, Transaction>> updateTransaction(
    String id, {
    String? type,
    double? amount,
    String? category,
    String? description,
    String? date,
    String? paymentMethod,
    List<String>? tags,
    String? notes,
  });
  
  /// Delete a transaction
  Future<Either<Failure, void>> deleteTransaction(String id);
  
  /// Get analytics data with optional date filtering
  Future<Either<Failure, AnalyticsData>> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get recent transactions
  @Deprecated('Use getTransactions instead')
  Future<Either<Failure, List<Transaction>>> getRecentTransactions({int limit = 10});

  /// Add a new transaction
  @Deprecated('Use createTransaction instead')
  Future<Either<Failure, void>> addTransaction(Transaction transaction);
}
