import 'package:hasibha/features/home/data/models/transaction_model.dart';
import 'package:hasibha/features/budget/domain/entities/budget.dart';
import 'package:hasibha/features/savings/domain/entities/savings_goal.dart';
import 'package:hasibha/features/notifications/domain/entities/notification.dart';
import 'package:hasibha/features/debt/domain/entities/debt.dart';
import 'package:hasibha/features/debt/domain/entities/debt_enums.dart';

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
  static List<SavingsGoal> getMockSavingsGoals() {
    final now = DateTime.now();
    return [
      SavingsGoal(
        id: 'sg_001',
        name: 'Vacation Fund',
        targetAmount: 5000.00,
        currentAmount: 3250.00,
        deadline: now.add(const Duration(days: 90)),
        color: 0xFFFFB300, // Orange-yellow
        icon: 'card_travel',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      SavingsGoal(
        id: 'sg_002',
        name: 'Emergency Fund',
        targetAmount: 10000.00,
        currentAmount: 7200.00,
        deadline: now.add(const Duration(days: 180)),
        color: 0xFF4CAF50, // Green
        icon: 'security',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 120)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      SavingsGoal(
        id: 'sg_003',
        name: 'New Laptop',
        targetAmount: 2500.00,
        currentAmount: 1580.00,
        deadline: now.add(const Duration(days: 60)),
        color: 0xFF2196F3, // Blue
        icon: 'laptop',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      SavingsGoal(
        id: 'sg_004',
        name: 'Car Fund',
        targetAmount: 15000.00,
        currentAmount: 4230.00,
        deadline: now.add(const Duration(days: 365)),
        color: 0xFF9C27B0, // Purple
        icon: 'directions_car',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 200)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  // Budget mock data
  static List<Budget> getMockBudgets() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    
    return [
      Budget(
        id: 'bud_001',
        categoryId: 'Food',
        limit: 500.00,
        period: BudgetPeriod.monthly,
        spent: 250.75,
        startDate: monthStart,
        endDate: monthEnd,
        isActive: true,
        alertSettings: const AlertSettings(
          enabled: true,
          threshold: 80.0,
          notifyOnExceed: true,
        ),
        createdAt: monthStart,
        updatedAt: now,
      ),
      Budget(
        id: 'bud_002',
        categoryId: 'Transport',
        limit: 200.00,
        period: BudgetPeriod.monthly,
        spent: 76.30,
        startDate: monthStart,
        endDate: monthEnd,
        isActive: true,
        alertSettings: const AlertSettings(
          enabled: true,
          threshold: 80.0,
          notifyOnExceed: true,
        ),
        createdAt: monthStart,
        updatedAt: now,
      ),
      Budget(
        id: 'bud_003',
        categoryId: 'Entertainment',
        limit: 150.00,
        period: BudgetPeriod.monthly,
        spent: 25.98,
        startDate: monthStart,
        endDate: monthEnd,
        isActive: true,
        alertSettings: const AlertSettings(
          enabled: true,
          threshold: 80.0,
          notifyOnExceed: true,
        ),
        createdAt: monthStart,
        updatedAt: now,
      ),
      Budget(
        id: 'bud_004',
        categoryId: 'Shopping',
        limit: 300.00,
        period: BudgetPeriod.monthly,
        spent: 96.98,
        startDate: monthStart,
        endDate: monthEnd,
        isActive: true,
        alertSettings: const AlertSettings(
          enabled: true,
          threshold: 80.0,
          notifyOnExceed: true,
        ),
        createdAt: monthStart,
        updatedAt: now,
      ),
      Budget(
        id: 'bud_005',
        categoryId: 'Bills',
        limit: 400.00,
        period: BudgetPeriod.monthly,
        spent: 264.99,
        startDate: monthStart,
        endDate: monthEnd,
        isActive: true,
        alertSettings: const AlertSettings(
          enabled: true,
          threshold: 80.0,
          notifyOnExceed: true,
        ),
        createdAt: monthStart,
        updatedAt: now,
      ),
      // Add one exceeded budget for testing
      Budget(
        id: 'bud_006',
        categoryId: 'Health',
        limit: 100.00,
        period: BudgetPeriod.monthly,
        spent: 125.50,
        startDate: monthStart,
        endDate: monthEnd,
        isActive: true,
        alertSettings: const AlertSettings(
          enabled: true,
          threshold: 80.0,
          notifyOnExceed: true,
        ),
        createdAt: monthStart,
        updatedAt: now,
      ),
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
    return goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
  }

  // Get overall savings progress
  static double getOverallProgress() {
    final goals = getMockSavingsGoals();
    final totalTarget = goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
    final totalCurrent = goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
    return totalCurrent / totalTarget;
  }
  
  // Get mock notifications
  static List<AppNotification> getMockNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'notif_001',
        title: 'Budget Alert: Health',
        body: "You've exceeded your Health budget by \$25.50",
        type: NotificationType.budgetAlert,
        priority: NotificationPriority.high,
        scheduledTime: now.subtract(const Duration(hours: 2)),
        sentTime: now.subtract(const Duration(hours: 2)),
        isSent: true,
        isRead: false,
      ),
      AppNotification(
        id: 'notif_002',
        title: 'Bill Reminder',
        body: 'Electricity bill due in 3 days',
        type: NotificationType.billReminder,
        priority: NotificationPriority.medium,
        scheduledTime: now.subtract(const Duration(hours: 5)),
        sentTime: now.subtract(const Duration(hours: 5)),
        isSent: true,
        isRead: true,
      ),
      AppNotification(
        id: 'notif_003',
        title: 'Savings Milestone! 🎉',
        body: "You've reached 65% of your Vacation Fund goal!",
        type: NotificationType.savingsMilestone,
        priority: NotificationPriority.medium,
        scheduledTime: now.subtract(const Duration(days: 1)),
        sentTime: now.subtract(const Duration(days: 1)),
        isSent: true,
        isRead: true,
      ),
      AppNotification(
        id: 'notif_004',
        title: 'Budget Warning: Food',
        body: "You've used 50% of your Food budget",
        type: NotificationType.budgetAlert,
        priority: NotificationPriority.low,
        scheduledTime: now.subtract(const Duration(days: 2)),
        sentTime: now.subtract(const Duration(days: 2)),
        isSent: true,
        isRead: true,
      ),
    ];
  }
  
  // Get mock user profile data
  static Map<String, dynamic> getMockUserProfile() {
    return {
      'id': 'user_001',
      'name': userName,
      'email': userEmail,
      'phone': '+1 234 567 8900',
      'avatar': null,
      'joinedDate': DateTime.now().subtract(const Duration(days: 180)),
      'currency': 'USD',
      'language': 'en',
      'enableNotifications': true,
      'enableBiometric': false,
      'totalExpenses': monthlyExpenses,
      'totalIncome': monthlyIncome,
      'totalBudgets': 6,
      'totalGoals': 4,
    };
  }

  // Debt mock data
  static List<Debt> getMockDebts() {
    final now = DateTime.now();
    return [
      Debt(
        id: 'debt_001',
        title: 'Home Loan',
        description: 'Monthly mortgage payment',
        amount: 250000.0,
        paidAmount: 45000.0,
        type: DebtType.OWED_BY_ME,
        contactName: 'Bank of America',
        createdDate: now.subtract(const Duration(days: 365 * 2)),
        dueDate: now.add(const Duration(days: 365 * 28)),
        status: DebtStatus.ACTIVE,
        interestRate: 4.5,
        paymentFrequency: PaymentFrequency.MONTHLY,
      ),
      Debt(
        id: 'debt_002',
        title: 'Car Loan',
        description: 'Auto financing',
        amount: 35000.0,
        paidAmount: 12000.0,
        type: DebtType.OWED_BY_ME,
        contactName: 'Toyota Financial',
        createdDate: now.subtract(const Duration(days: 365)),
        dueDate: now.add(const Duration(days: 365 * 3)),
        status: DebtStatus.PARTIALLY_PAID,
        interestRate: 2.9,
        paymentFrequency: PaymentFrequency.MONTHLY,
      ),
      Debt(
        id: 'debt_003',
        title: 'Loan to John',
        description: 'Personal loan to John for his business',
        amount: 5000.0,
        paidAmount: 1500.0,
        type: DebtType.OWED_TO_ME,
        contactName: 'John Doe',
        createdDate: now.subtract(const Duration(days: 60)),
        dueDate: now.add(const Duration(days: 300)),
        status: DebtStatus.ACTIVE,
        paymentFrequency: PaymentFrequency.MONTHLY,
      ),
      Debt(
        id: 'debt_004',
        title: 'Credit Card',
        description: 'Chase Sapphire Preferred',
        amount: 1200.0,
        paidAmount: 0.0,
        type: DebtType.OWED_BY_ME,
        contactName: 'Chase',
        createdDate: now.subtract(const Duration(days: 15)),
        dueDate: now.add(const Duration(days: 15)),
        status: DebtStatus.ACTIVE,
        paymentFrequency: PaymentFrequency.MONTHLY,
      ),
      Debt(
        id: 'debt_005',
        title: 'Freelance Work Owed',
        description: 'Payment for web design work',
        amount: 2500.0,
        paidAmount: 0.0,
        type: DebtType.OWED_TO_ME,
        contactName: 'Tech Startup Inc',
        createdDate: now.subtract(const Duration(days: 30)),
        dueDate: now.subtract(const Duration(days: 2)),
        status: DebtStatus.OVERDUE,
      ),
    ];
  }

  // Mock debt summary
  static Map<String, double> getMockDebtSummary() {
    return {
      'total_owed_by_me': 274200.0,
      'total_owed_to_me': 7500.0,
      'net_debt': 266700.0,
      'paid_amount': 58500.0,
      'overdue_count': 1,
    };
  }
}
