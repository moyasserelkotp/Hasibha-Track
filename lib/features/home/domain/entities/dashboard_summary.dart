import 'package:equatable/equatable.dart';
import 'package:hasibha/features/home/domain/entities/transaction.dart';

class DashboardSummary extends Equatable {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final List<Transaction> recentTransactions;
  final Map<String, double> categoryBreakdown;

  const DashboardSummary({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.recentTransactions,
    required this.categoryBreakdown,
  });

  @override
  List<Object?> get props => [
        totalBalance,
        totalIncome,
        totalExpense,
        recentTransactions,
        categoryBreakdown,
      ];
}
