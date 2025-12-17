import 'package:hasibha/features/home/data/models/transaction_model.dart';

/// Comprehensive mock data provider for testing the entire application
class MockDataProvider {
  // User Profile
  static const String userName = 'Sarah Johnson';
  static const String userEmail = 'sarah.johnson@email.com';
  static const double totalBalance = 12547.32;
  static const double monthlyIncome = 8500.00;
  static const double monthlyExpenses = 3252.68;
  
  // Mock transactions
  static final List<TransactionModel> mockTransactions = [
    // Recent transactions - last 7 days
    TransactionModel(
      id: 'tx_001',
      title: 'Grocery Shopping',
      amount: 142.50,
      category: 'Food',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      description: 'Weekly groceries at Whole Foods',
    ),
    TransactionModel(
      id: 'tx_002',
      title: 'Salary Deposit',
      amount: 8500.00,
      category: 'Income',
      type: 'income',
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Monthly salary',
    ),
    TransactionModel(
      id: 'tx_003',
      title: 'Uber Ride',
      amount: 24.30,
      category: 'Transport',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      description: 'Ride to downtown',
    ),
    TransactionModel(
      id: 'tx_004',
      title: 'Netflix Subscription',
      amount: 15.99,
      category: 'Entertainment',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Monthly subscription',
    ),
    TransactionModel(
      id: 'tx_005',
      title: 'Coffee Shop',
      amount: 12.75,
      category: 'Food',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
      description: 'Morning coffee and pastry',
    ),
    TransactionModel(
      id: 'tx_006',
      title: 'Electricity Bill',
      amount: 185.00,
      category: 'Bills',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 3)),
      description: 'Monthly utility payment',
    ),
    TransactionModel(
      id: 'tx_007',
      title: 'Amazon Purchase',
      amount: 67.99,
      category: 'Shopping',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 4)),
      description: 'Books and office supplies',
    ),
    TransactionModel(
      id: 'tx_008',
      title: 'Gym Membership',
      amount: 49.99,
      category: 'Health',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Monthly gym membership',
    ),
    TransactionModel(
      id: 'tx_009',
      title: 'Restaurant Dinner',
      amount: 95.50,
      category: 'Food',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 6)),
      description: 'Dinner with friends',
    ),
    TransactionModel(
      id: 'tx_010',
      title: 'Freelance Project',
      amount: 550.00,
      category: 'Income',
      type: 'income',
      date: DateTime.now().subtract(const Duration(days: 7)),
      description: 'Web design project payment',
    ),
    TransactionModel(
      id: 'tx_011',
      title: 'Gas Station',
      amount: 52.00,
      category: 'Transport',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 7, hours: 5)),
      description: 'Fuel refill',
    ),
    TransactionModel(
      id: 'tx_012',
      title: 'Spotify Premium',
      amount: 9.99,
      category: 'Entertainment',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 8)),
      description: 'Music subscription',
    ),
    // Older transactions
    TransactionModel(
      id: 'tx_013',
      title: 'Pharmacy',
      amount: 34.50,
      category: 'Health',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 10)),
      description: 'Medication and vitamins',
    ),
    TransactionModel(
      id: 'tx_014',
      title: 'Book Store',
      amount: 28.99,
      category: 'Shopping',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 12)),
      description: 'New release novels',
    ),
    TransactionModel(
      id: 'tx_015',
      title: 'Internet Bill',
      amount: 79.99,
      category: 'Bills',
      type: 'expense',
      date: DateTime.now().subtract(const Duration(days: 15)),
      description: 'Monthly internet service',
    ),
  ];

  // Category breakdown for charts
  static Map<String, double> getCategoryBreakdown() {
    return {
      'Food': 250.75,
      'Transport': 76.30,
      'Shopping': 96.98,
      'Entertainment': 25.98,
      'Bills': 264.99,
      'Health': 84.49,
    };
  }

  // Savings goals mock data
  static List<Map<String, dynamic>> getMockSavingsGoals() {
    return [
      {
        'id': 'sg_001',
        'name': 'Vacation Fund',
        'targetAmount': 5000.00,
        'currentAmount': 3250.00,
        'deadline': DateTime.now().add(const Duration(days: 90)),
        'color': '#FFB300', // Orange-yellow
        'icon': 'card_travel',
      },
      {
        'id': 'sg_002',
        'name': 'Emergency Fund',
        'targetAmount': 10000.00,
        'currentAmount': 7200.00,
        'deadline': DateTime.now().add(const Duration(days: 180)),
        'color': '#4CAF50', // Green
        'icon': 'security',
      },
      {
        'id': 'sg_003',
        'name': 'New Laptop',
        'targetAmount': 2500.00,
        'currentAmount': 1580.00,
        'deadline': DateTime.now().add(const Duration(days: 60)),
        'color': '#2196F3', // Blue
        'icon': 'laptop',
      },
      {
        'id': 'sg_004',
        'name': 'Car Fund',
        'targetAmount': 15000.00,
        'currentAmount': 4230.00,
        'deadline': DateTime.now().add(const Duration(days: 365)),
        'color': '#9C27B0', // Purple
        'icon': 'directions_car',
      },
    ];
  }

  // Budget mock data
  static List<Map<String, dynamic>> getMockBudgets() {
    return [
      {
        'id': 'bud_001',
        'category': 'Food & Dining',
        'budgetAmount': 500.00,
        'spentAmount': 250.75,
        'period': 'monthly',
        'color': '#FF6B6B',
      },
      {
        'id': 'bud_002',
        'category': 'Transportation',
        'budgetAmount': 200.00,
        'spentAmount': 76.30,
        'period': 'monthly',
        'color': '#4ECDC4',
      },
      {
        'id': 'bud_003',
        'category': 'Entertainment',
        'budgetAmount': 150.00,
        'spentAmount': 25.98,
        'period': 'monthly',
        'color': '#95E1D3',
      },
      {
        'id': 'bud_004',
        'category': 'Shopping',
        'budgetAmount': 300.00,
        'spentAmount': 96.98,
        'period': 'monthly',
        'color': '#FFE66D',
      },
      {
        'id': 'bud_005',
        'category': 'Bills & Utilities',
        'budgetAmount': 400.00,
        'spentAmount': 264.99,
        'period': 'monthly',
        'color': '#F38181',
      },
    ];
  }

  // Shared budget mock data
  static List<Map<String, dynamic>> getMockSharedBudgets() {
    return [
      {
        'id': 'sb_001',
        'name': 'Roommates Budget',
        'totalBudget': 2000.00,
        'totalSpent': 1240.50,
        'members': [
          {
            'id': 'mem_001',
            'name': 'Sarah Johnson',
            'role': 'Admin',
            'avatar': 'S',
            'spent': 425.00,
          },
          {
            'id': 'mem_002',
            'name': 'Mike Chen',
            'role': 'Member',
            'avatar': 'M',
            'spent': 582.50,
          },
          {
            'id': 'mem_003',
            'name': 'Emma Davis',
            'role': 'Member',
            'avatar': 'E',
            'spent': 233.00,
          },
        ],
        'recentExpenses': [
          {
            'id': 'se_001',
            'title': 'Rent Payment',
            'amount': 800.00,
            'paidBy': 'Mike Chen',
            'date': DateTime.now().subtract(const Duration(days: 2)),
          },
          {
            'id': 'se_002',
            'title': 'Groceries',
            'amount': 156.50,
            'paidBy': 'Sarah Johnson',
            'date': DateTime.now().subtract(const Duration(days: 5)),
          },
        ],
      },
      {
        'id': 'sb_002',
        'name': 'Family Trip',
        'totalBudget': 5000.00,
        'totalSpent': 2345.75,
        'members': [
          {
            'id': 'mem_004',
            'name': 'Sarah Johnson',
            'role': 'Admin',
            'avatar': 'S',
            'spent': 1200.00,
          },
          {
            'id': 'mem_005',
            'name': 'John Johnson',
            'role': 'Member',
            'avatar': 'J',
            'spent': 1145.75,
          },
        ],
        'recentExpenses': [],
      },
    ];
  }

  // AI Insights mock data
  static List<String> getMockAIInsights() {
    return [
      'Your spending is on track this month!',
      'You spent 23% more on dining this week',
      'Great job! You saved \$200 more than last month',
      'Your grocery spending decreased by 15%',
      'Congratulations! You reached your savings goal',
      'Consider reducing entertainment expenses',
    ];
  }

  // Upcoming bills
  static List<Map<String, dynamic>> getUpcomingBills() {
    return [
      {
        'title': 'Rent',
        'amount': 1200.00,
        'dueDate': DateTime.now().add(const Duration(days: 5)),
        'category': 'Bills',
      },
      {
        'title': 'Car Insurance',
        'amount': 125.00,
        'dueDate': DateTime.now().add(const Duration(days: 12)),
        'category': 'Bills',
      },
      {
        'title': 'Credit Card',
        'amount': 450.00,
        'dueDate': DateTime.now().add(const Duration(days: 18)),
        'category': 'Bills',
      },
    ];
  }

  // Analytics data
  static Map<String, dynamic> getMonthlyAnalytics() {
    return {
      'currentMonth': {
        'income': 8500.00,
        'expenses': 3252.68,
        'savings': 5247.32,
        'savingsRate': 0.62, // 62%
      },
      'lastMonth': {
        'income': 8200.00,
        'expenses': 3580.00,
        'savings': 4620.00,
        'savingsRate': 0.56,
      },
      'trend': 'improving', // improving, declining, stable
    };
  }

  // Get recent transactions (last 5)
  static List<TransactionModel> getRecentTransactions() {
    return mockTransactions.take(5).toList();
  }

  // Get all transactions
  static List<TransactionModel> getAllTransactions() {
    return mockTransactions;
  }

  // Get transactions by category
  static List<TransactionModel> getTransactionsByCategory(String category) {
    return mockTransactions
        .where((tx) => tx.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Get total saved across all goals
  static double getTotalSaved() {
    final goals = getMockSavingsGoals();
    return goals.fold(
        0.0, (sum, goal) => sum + (goal['currentAmount'] as double));
  }

  // Get overall savings progress
  static double getOverallProgress() {
    final goals = getMockSavingsGoals();
    final totalTarget =
        goals.fold(0.0, (sum, goal) => sum + (goal['targetAmount'] as double));
    final totalCurrent = goals.fold(
        0.0, (sum, goal) => sum + (goal['currentAmount'] as double));
    return totalCurrent / totalTarget;
  }
}
