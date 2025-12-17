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

  // Getters for backwards compatibility
  double get totalSpending => totalSpent;
  double get totalIncome => 0.0; // Not tracked in this entity, return 0
  double get savingsRate => 0.0; // Calculate if needed: (income - spending) / income
  double get averageDailySpending => averageDaily;
  
  List<CategorySpending> get topCategories {
    // Convert categoryBreakdown map to sorted list of CategorySpending
    final totalSpent = this.totalSpent;
    final categories = categoryBreakdown.entries.map((entry) {
      return CategorySpending(
        categoryId: entry.key,
        categoryName: entry.key, // In real app, look up name from ID
        amount: entry.value,
        percentage: totalSpent > 0 ? (entry.value / totalSpent) * 100 : 0,
      );
    }).toList();
    
    // Sort by amount descending and return top categories
    categories.sort((a, b) => b.amount.compareTo(a.amount));
    return categories;
  }
  
  String? get highestSpendingDay {
    if (dailyTrend.isEmpty) return null;
    final highest = dailyTrend.reduce((a, b) => a.amount > b.amount ? a : b);
    return '${highest.date.year}-${highest.date.month.toString().padLeft(2, '0')}-${highest.date.day.toString().padLeft(2, '0')}';
  }
  
  String? get mostFrequentCategory {
    if (categoryBreakdown.isEmpty) return null;
    final sorted = categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

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
