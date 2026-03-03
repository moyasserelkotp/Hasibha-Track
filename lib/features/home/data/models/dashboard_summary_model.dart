
import '../../domain/entities/dashboard_summary.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.totalBalance,
    required super.totalIncome,
    required super.totalExpense,
    required super.recentTransactions,
    required super.categoryBreakdown,
    super.userName,
    super.monthlyIncome,
    super.monthlyExpenses,
    super.unreadNotifications,
    super.activeBudgets,
    super.budgetsOnTrack,
    super.savingsGoals,
    super.goalsAchieved,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    // New backend shape:
    // {
    //   "user": { "name": "...", "photo": "...", "currency": "EGP" },
    //   "balance": {
    //     "total": 7499.5,
    //     "income": 8500,
    //     "expense": 1000.5,
    //     "period": "This Month"
    //   },
    //   "quickActions": [ ... ]
    // }
    final balance = json['balance'] as Map<String, dynamic>? ?? const {};
    final user = json['user'] as Map<String, dynamic>? ?? const {};

    return DashboardSummaryModel(
      totalBalance: (balance['total'] as num?)?.toDouble() ?? 0.0,
      totalIncome: (balance['income'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (balance['expense'] as num?)?.toDouble() ?? 0.0,
      // New dashboard endpoint does not yet return recent transactions
      recentTransactions: const [],
      // And it does not include category breakdown in this response
      categoryBreakdown: const {},
      userName: user['name'] as String?,
      // Use income/expense as monthly defaults
      monthlyIncome: (balance['income'] as num?)?.toDouble(),
      monthlyExpenses: (balance['expense'] as num?)?.toDouble(),
      // Not provided by backend dashboard response yet
      unreadNotifications: 0,
      activeBudgets: null,
      budgetsOnTrack: null,
      savingsGoals: null,
      goalsAchieved: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'recentTransactions': recentTransactions,
      'categoryBreakdown': categoryBreakdown,
      'userName': userName,
      'monthlyIncome': monthlyIncome,
      'monthlyExpenses': monthlyExpenses,
      'unreadNotifications': unreadNotifications,
      'activeBudgets': activeBudgets,
      'budgetsOnTrack': budgetsOnTrack,
      'savingsGoals': savingsGoals,
      'goalsAchieved': goalsAchieved,
    };
  }
}
