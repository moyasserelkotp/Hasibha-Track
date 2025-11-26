import 'package:equatable/equatable.dart';

/// Analytics data for spending insights
class SpendingAnalytics extends Equatable {
  final double totalSpent;
  final double averageDaily;
  final double averageWeekly;
  final double averageMonthly;
  final Map<String, double> categoryBreakdown; // categoryId -> amount
  final List<DailySpending> dailyTrend;
  final List<MonthlySpending> monthlyTrend;
  final DateTime startDate;
  final DateTime endDate;

  const SpendingAnalytics({
    required this.totalSpent,
    required this.averageDaily,
    required this.averageWeekly,
    required this.averageMonthly,
    required this.categoryBreakdown,
    required this.dailyTrend,
    required this.monthlyTrend,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        totalSpent,
        averageDaily,
        averageWeekly,
        averageMonthly,
        categoryBreakdown,
        dailyTrend,
        monthlyTrend,
        startDate,
        endDate,
      ];
}

/// Daily spending data point
class DailySpending extends Equatable {
  final DateTime date;
  final double amount;

  const DailySpending({
    required this.date,
    required this.amount,
  });

  @override
  List<Object?> get props => [date, amount];
}

/// Monthly spending data point
class MonthlySpending extends Equatable {
  final int year;
  final int month;
  final double amount;

  const MonthlySpending({
    required this.year,
    required this.month,
    required this.amount,
  });

  String get monthName {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  List<Object?> get props => [year, month, amount];
}

/// Category spending data
class CategorySpending extends Equatable {
  final String categoryId;
  final String categoryName;
  final double amount;
  final double percentage; // % of total spending

  const CategorySpending({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.percentage,
  });

  @override
  List<Object?> get props => [categoryId, categoryName, amount, percentage];
}
