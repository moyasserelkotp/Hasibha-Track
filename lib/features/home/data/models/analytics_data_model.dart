import '../../domain/entities/analytics_data.dart';

class AnalyticsDataModel extends AnalyticsData {
  const AnalyticsDataModel({
    required super.categoryBreakdown,
    required super.monthlyTrends,
    required super.totalIncome,
    required super.totalExpense,
    required super.netSavings,
    required super.topSpendingCategory,
    required super.startDate,
    required super.endDate,
  });

  factory AnalyticsDataModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsDataModel(
      categoryBreakdown: Map<String, double>.from(json['category_breakdown'] ?? {}),
      monthlyTrends: (json['monthly_trends'] as List?)
              ?.map((e) => MonthlyDataModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (json['total_expense'] as num?)?.toDouble() ?? 0.0,
      netSavings: (json['net_savings'] as num?)?.toDouble() ?? 0.0,
      topSpendingCategory: json['top_spending_category'] as String? ?? '',
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_breakdown': categoryBreakdown,
      'monthly_trends': monthlyTrends.map((e) => (e as MonthlyDataModel).toJson()).toList(),
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'net_savings': netSavings,
      'top_spending_category': topSpendingCategory,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}

class MonthlyDataModel extends MonthlyData {
  const MonthlyDataModel({
    required super.month,
    required super.income,
    required super.expense,
    required super.savings,
  });

  factory MonthlyDataModel.fromJson(Map<String, dynamic> json) {
    return MonthlyDataModel(
      month: json['month'] as String,
      income: (json['income'] as num?)?.toDouble() ?? 0.0,
      expense: (json['expense'] as num?)?.toDouble() ?? 0.0,
      savings: (json['savings'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'income': income,
      'expense': expense,
      'savings': savings,
    };
  }
}
