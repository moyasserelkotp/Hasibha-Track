import 'package:dartz/dartz.dart';

import '../../../../shared/core/failure.dart';
import '../entities/dashboard_summary.dart';
import '../entities/transaction.dart';
import '../entities/analytics_data.dart';


abstract class HomeRepository {
  /// Get dashboard summary with financial overview
  Future<Either<Failure, DashboardSummary>> getDashboardSummary();
  
  /// Get recent transactions
  Future<Either<Failure, List<Transaction>>> getRecentTransactions({int limit = 10});
  
  /// Add a new transaction
  Future<Either<Failure, void>> addTransaction(Transaction transaction);
  
  /// Get analytics data with optional date filtering
  Future<Either<Failure, AnalyticsData>> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  });
}
