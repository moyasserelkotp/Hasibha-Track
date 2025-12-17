import '../../../../../shared/data/mock_data_provider.dart';
import '../../models/analytics_models.dart';

abstract class AnalyticsRemoteDataSource {
  Future<SpendingAnalyticsModel> getSpendingAnalytics({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<CategorySpendingModel>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<DailySpendingModel>> getSpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<MonthlySpendingModel>> getMonthlyComparison({
    required int year,
  });
}

/// Mock implementation of Analytics Remote Data Source
class MockAnalyticsRemoteDataSource implements AnalyticsRemoteDataSource {
  @override
  Future<SpendingAnalyticsModel> getSpendingAnalytics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final categoryBreakdown = MockDataProvider.getCategoryBreakdown();
    final totalSpent = categoryBreakdown.values.fold(0.0, (sum, amount) => sum + amount);
    final days = endDate.difference(startDate).inDays + 1;

    return SpendingAnalyticsModel(
      totalSpent: totalSpent,
      averageDaily: totalSpent / days,
      averageWeekly: (totalSpent / days) * 7,
      averageMonthly: (totalSpent / days) * 30,
      categoryBreakdown: categoryBreakdown,
      dailyTrend: _generateDailyTrend(startDate, endDate),
      monthlyTrend: _generateMonthlyTrend(startDate.year),
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<List<CategorySpendingModel>> getCategoryBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final categoryBreakdown = MockDataProvider.getCategoryBreakdown();
    final totalSpent = categoryBreakdown.values.fold(0.0, (sum, amount) => sum + amount);

    return categoryBreakdown.entries
        .map((e) => CategorySpendingModel(
              categoryId: e.key.toLowerCase().replaceAll(' ', '_'),
              categoryName: e.key,
              amount: e.value,
              percentage: (e.value / totalSpent * 100),
            ))
        .toList();
  }

  @override
  Future<List<DailySpendingModel>> getSpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _generateDailyTrend(startDate, endDate);
  }

  @override
  Future<List<MonthlySpendingModel>> getMonthlyComparison({
    required int year,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _generateMonthlyTrend(year);
  }

  List<DailySpendingModel> _generateDailyTrend(DateTime startDate, DateTime endDate) {
    final days = endDate.difference(startDate).inDays;
    final dailyTrend = <DailySpendingModel>[];

    for (int i = 0; i <= days; i++) {
      final date = startDate.add(Duration(days: i));
      final baseAmount = 50.0 + (i % 7) * 30.0;
      final variance = (i % 3) * 20.0;
      final amount = baseAmount + variance;

      dailyTrend.add(DailySpendingModel(
        date: date,
        amount: amount,
      ));
    }

    return dailyTrend;
  }

  List<MonthlySpendingModel> _generateMonthlyTrend(int year) {
    final now = DateTime.now();
    final monthlyTrend = <MonthlySpendingModel>[];

    for (int month = 1; month <= 12; month++) {
      final isPastMonth = year < now.year || (year == now.year && month <= now.month);
      final amount = isPastMonth
          ? 2500.0 + (month * 150.0) + ((month % 3) * 200.0)
          : 0.0;

      monthlyTrend.add(MonthlySpendingModel(
        year: year,
        month: month,
        amount: amount,
      ));
    }

    return monthlyTrend;
  }
}
