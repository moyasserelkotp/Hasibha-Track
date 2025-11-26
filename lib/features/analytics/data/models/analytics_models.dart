import '../../domain/entities/spending_analytics.dart';

class SpendingAnalyticsModel extends SpendingAnalytics {
  const SpendingAnalyticsModel({
    required super.totalSpent,
    required super.averageDaily,
    required super.averageWeekly,
    required super.averageMonthly,
    required super.categoryBreakdown,
    required super.dailyTrend,
    required super.monthlyTrend,
    required super.startDate,
    required super.endDate,
  });

  factory SpendingAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return SpendingAnalyticsModel(
      totalSpent: (json['total_spent'] as num).toDouble(),
      averageDaily: (json['average_daily'] as num).toDouble(),
      averageWeekly: (json['average_weekly'] as num).toDouble(),
      averageMonthly: (json['average_monthly'] as num).toDouble(),
      categoryBreakdown: Map<String, double>.from(
        (json['category_breakdown'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      dailyTrend: (json['daily_trend'] as List)
          .map((e) => DailySpendingModel.fromJson(e))
          .toList(),
      monthlyTrend: (json['monthly_trend'] as List)
          .map((e) => MonthlySpendingModel.fromJson(e))
          .toList(),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );
  }
}

class DailySpendingModel extends DailySpending {
  const DailySpendingModel({
    required super.date,
    required super.amount,
  });

  factory DailySpendingModel.fromJson(Map<String, dynamic> json) {
    return DailySpendingModel(
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class MonthlySpendingModel extends MonthlySpending {
  const MonthlySpendingModel({
    required super.year,
    required super.month,
    required super.amount,
  });

  factory MonthlySpendingModel.fromJson(Map<String, dynamic> json) {
    return MonthlySpendingModel(
      year: json['year'] as int,
      month: json['month'] as int,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class CategorySpendingModel extends CategorySpending {
  const CategorySpendingModel({
    required super.categoryId,
    required super.categoryName,
    required super.amount,
    required super.percentage,
  });

  factory CategorySpendingModel.fromJson(Map<String, dynamic> json) {
    return CategorySpendingModel(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
