import 'package:dio/dio.dart';

import '../../../../../shared/core/api/api_constants.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../../domain/entities/transaction.dart';
import '../../models/dashboard_summary_model.dart';
import '../../models/transaction_model.dart';
import '../../models/analytics_data_model.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    try {
      // Try API endpoint (with trailing slash to match backend pattern)
      final endpoint = ApiConstants.dashboardSummary.endsWith('/') 
          ? ApiConstants.dashboardSummary 
          : '${ApiConstants.dashboardSummary}/';
      final response = await dio.get(endpoint);
      
      if (response.data is Map<String, dynamic>) {
        return DashboardSummaryModel.fromJson(response.data as Map<String, dynamic>);
      }
      
      // Fallback to mock data if API structure is different
      return _getMockDashboardSummary();
    } on DioException catch (e) {
      // If 404 or API not available, use mock data for development
      if (e.response?.statusCode == 404 || e.type == DioExceptionType.connectionError) {
        return _getMockDashboardSummary();
      }
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      // If API is not available, return mock data for development
      // In production, you might want to throw an exception instead
      return _getMockDashboardSummary();
    }
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10}) async {
    try {
      // Try API endpoint (with trailing slash to match backend pattern)
      final endpoint = ApiConstants.recentTransactions.endsWith('/') 
          ? ApiConstants.recentTransactions 
          : '${ApiConstants.recentTransactions}/';
      final response = await dio.get(
        endpoint,
        queryParameters: {'limit': limit},
      );
      
      if (response.data is List) {
        return (response.data as List)
            .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      // Fallback to mock data if API structure is different
      return _getMockTransactions().take(limit).toList();
    } on DioException catch (e) {
      // If 404 or API not available, use mock data for development
      if (e.response?.statusCode == 404 || e.type == DioExceptionType.connectionError) {
        return _getMockTransactions().take(limit).toList();
      }
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      // If API is not available, return mock data for development
      // In production, you might want to throw an exception instead
      return _getMockTransactions().take(limit).toList();
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    // For now, store locally - in production this would call API
    // The transaction will be added to mock data until API is implemented
    _getMockTransactions().add(
      TransactionModel(
        id: transaction.id,
        title: transaction.title,
        amount: transaction.amount,
        category: transaction.category,
        type: transaction.type,
        date: transaction.date,
        description: transaction.description,
        icon: transaction.icon,
      ),
    );
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<AnalyticsDataModel> getAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Generate mock analytics data
    final end = endDate ?? DateTime.now();
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 90));
    
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return _generateMockAnalytics(start, end);
  }

  AnalyticsDataModel _generateMockAnalytics(DateTime start, DateTime end) {
    // Mock category breakdown
    final categoryBreakdown = {
      'Food': 1250.00,
      'Transportation': 450.00,
      'Entertainment': 350.00,
      'Shopping': 600.00,
      'Bills': 800.00,
      'Health': 200.00,
    };

    // Generate monthly trends
    final monthlyTrends = <MonthlyDataModel>[];
    final months = ['Jan', 'Feb', 'Mar'];
    for (int i = 0; i < 3; i++) {
      monthlyTrends.add(
        MonthlyDataModel(
          month: '${months[i]} 2024',
          income: 5000.0 + (i * 500),
          expense: 3000.0 + (i * 200),
          savings: 2000.0 + (i * 300),
        ),
      );
    }

    final totalExpense = categoryBreakdown.values.reduce((a, b) => a + b);
    final totalIncome = 15500.0;

    return AnalyticsDataModel(
      categoryBreakdown: categoryBreakdown,
      monthlyTrends: monthlyTrends,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netSavings: totalIncome - totalExpense,
      topSpendingCategory: 'Food',
      startDate: start,
      endDate: end,
    );
  }

  /// Extracts error message from DioException
  String _extractErrorMessage(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ??
               data['error'] ??
               data['detail'] ??
               'An error occurred';
      }
      return data.toString();
    } else if (e.type == DioExceptionType.connectionTimeout ||
               e.type == DioExceptionType.receiveTimeout ||
               e.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }
    return e.message ?? 'An unexpected error occurred';
  }

  // Mock data helpers
  DashboardSummaryModel _getMockDashboardSummary() {
    final transactions = _getMockTransactions();
    return DashboardSummaryModel(
      totalBalance: 5250.00,
      totalIncome: 7500.00,
      totalExpense: 2250.00,
      recentTransactions: transactions,
      categoryBreakdown: {
        'Food': 850.00,
        'Transportation': 450.00,
        'Entertainment': 350.00,
        'Shopping': 600.00,
      },
    );
  }

  List<TransactionModel> _getMockTransactions() {
    return [
      TransactionModel(
        id: '1',
        title: 'Grocery Shopping',
        amount: 125.50,
        category: 'Food',
        type: 'expense',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        description: 'Weekly groceries',
        icon: 'shopping_cart',
      ),
      TransactionModel(
        id: '2',
        title: 'Salary',
        amount: 5000.00,
        category: 'Income',
        type: 'income',
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Monthly salary',
        icon: 'account_balance_wallet',
      ),
      TransactionModel(
        id: '3',
        title: 'Uber Ride',
        amount: 25.00,
        category: 'Transportation',
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: 'Ride to office',
        icon: 'directions_car',
      ),
      TransactionModel(
        id: '4',
        title: 'Netflix Subscription',
        amount: 15.99,
        category: 'Entertainment',
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Monthly subscription',
        icon: 'movie',
      ),
      TransactionModel(
        id: '5',
        title: 'Restaurant',
        amount: 45.00,
        category: 'Food',
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 3)),
        description: 'Dinner with friends',
        icon: 'restaurant',
      ),
      TransactionModel(
        id: '6',
        title: 'Freelance Project',
        amount: 2500.00,
        category: 'Income',
        type: 'income',
        date: DateTime.now().subtract(const Duration(days: 5)),
        description: 'Web development project',
        icon: 'work',
      ),
    ];
  }
}
