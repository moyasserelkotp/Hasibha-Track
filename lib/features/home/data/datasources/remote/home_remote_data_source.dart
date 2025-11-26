
import '../../../domain/entities/transaction.dart';
import '../../models/dashboard_summary_model.dart';
import '../../models/transaction_model.dart';
import '../../models/analytics_data_model.dart';

abstract class HomeRemoteDataSource {
  /// Fetch dashboard summary from API
  Future<DashboardSummaryModel> getDashboardSummary();
  
  /// Fetch recent transactions from API
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10});
  
  /// Add a new transaction
  Future<void> addTransaction(Transaction transaction);
  
  /// Get analytics data
  Future<AnalyticsDataModel> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  });
}
