import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/spending_analytics.dart';

/// Repository contract for analytics data
abstract class AnalyticsRepository {
  /// Get spending analytics for a date range
  Future<Either<Failure, SpendingAnalytics>> getSpendingAnalytics({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get category breakdown for a period
  Future<Either<Failure, List<CategorySpending>>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get spending trend (daily data points)
  Future<Either<Failure, List<DailySpending>>> getSpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get monthly comparison data
  Future<Either<Failure, List<MonthlySpending>>> getMonthlyComparison({
    required int year,
  });

  /// Get top spending categories
  Future<Either<Failure, List<CategorySpending>>> getTopCategories({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 5,
  });
}
