
import 'package:hasibha/features/home/data/models/transaction_model.dart';

import '../../domain/entities/dashboard_summary.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.totalBalance,
    required super.totalIncome,
    required super.totalExpense,
    required super.recentTransactions,
    required super.categoryBreakdown,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalBalance: (json['totalBalance'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      recentTransactions: (json['recentTransactions'] as List)
          .map((t) => TransactionModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      categoryBreakdown: Map<String, double>.from(
        (json['categoryBreakdown'] as Map).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'recentTransactions': recentTransactions
          .map((t) => (t as TransactionModel).toJson())
          .toList(),
      'categoryBreakdown': categoryBreakdown,
    };
  }
}
