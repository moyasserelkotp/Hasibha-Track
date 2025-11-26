import 'package:equatable/equatable.dart';

/// Entity representing analytics data for financial insights
class AnalyticsData extends Equatable {
  final Map<String, double> categoryBreakdown; // Category name -> total amount
  final List<MonthlyData> monthlyTrends;
  final double totalIncome;
  final double totalExpense;
  final double netSavings;
  final String topSpendingCategory;
  final DateTime startDate;
  final DateTime endDate;

  const AnalyticsData({
    required this.categoryBreakdown,
    required this.monthlyTrends,
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.topSpendingCategory,
required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        categoryBreakdown,
        monthlyTrends,
        totalIncome,
        totalExpense,
        netSavings,
        topSpendingCategory,
        startDate,
        endDate,
      ];
}

/// Monthly data point for trend analysis
class MonthlyData extends Equatable {
  final String month; // e.g., "Jan 2024"
  final double income;
  final double expense;
  final double savings;

  const MonthlyData({
    required this.month,
    required this.income,
    required this.expense,
    required this.savings,
  });

  @override
  List<Object?> get props => [month, income, expense, savings];
}
