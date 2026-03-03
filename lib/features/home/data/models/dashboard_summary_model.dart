
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
    final balance = json['balance'] as Map<String, dynamic>? ?? const {};
    final user = json['user'] as Map<String, dynamic>? ?? const {};

    return DashboardSummaryModel(
      totalBalance: (balance['total'] as num?)?.toDouble() ?? 0.0,
      totalIncome: (balance['income'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (balance['expense'] as num?)?.toDouble() ?? 0.0,
      recentTransactions: const [],
      categoryBreakdown: const {},
      userName: user['name'] as String?,
      monthlyIncome: (balance['income'] as num?)?.toDouble(),
      monthlyExpenses: (balance['expense'] as num?)?.toDouble(),
      unreadNotifications: 0,
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
