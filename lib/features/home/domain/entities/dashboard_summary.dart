import 'package:equatable/equatable.dart';
import 'package:hasibha/features/home/domain/entities/transaction.dart';

class DashboardSummary extends Equatable {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final List<Transaction> recentTransactions;
  final Map<String, double> categoryBreakdown;
  
  // Additional fields for modern UI
  final String? userName;
  final double monthlyIncome;
  final double monthlyExpenses;
  final int unreadNotifications;
  
  // Budget and savings stats
  final int? activeBudgets;
  final int? budgetsOnTrack;
  final int? savingsGoals;
  final int? goalsAchieved;

  const DashboardSummary({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.recentTransactions,
    required this.categoryBreakdown,
    this.userName,
    double? monthlyIncome,
    double? monthlyExpenses,
    this.unreadNotifications = 0,
    this.activeBudgets,
    this.budgetsOnTrack,
    this.savingsGoals,
    this.goalsAchieved,
  })  : monthlyIncome = monthlyIncome ?? totalIncome,
        monthlyExpenses = monthlyExpenses ?? totalExpense;

  @override
  List<Object?> get props => [
        totalBalance,
        totalIncome,
        totalExpense,
        recentTransactions,
        categoryBreakdown,
        userName,
        monthlyIncome,
        monthlyExpenses,
        unreadNotifications,
        activeBudgets,
        budgetsOnTrack,
        savingsGoals,
        goalsAchieved,
      ];
}
