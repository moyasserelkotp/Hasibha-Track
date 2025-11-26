class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addTransaction = '/add-transaction';
  static const String analytics = '/analytics';
  static const String export = '/export';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String splashScreen = '/splash-screen';
  static const String otpConfirm= '/otp-confirm';
  static const String resetPasswordFinish= '/reset-password-finish';
  static const String resetPasswordConfirmOtp= '/reset-password-confirm-otp';
  static const String resetPasswordSendEmail= '/reset-password-send-email';
  static const String changePassword= '/change-password';
  
  // Expense Routes
  static const String expenses = '/expenses';
  static const String addExpense = '/expenses/add';
  static const String expenseDetail = '/expenses/:id';
  
  // Budget Routes
  static const String budgets = '/budgets';
  static const String createBudget = '/budgets/create';
  static const String editBudget = '/budgets/edit/:id';
  
  // Savings Routes
  static const String savings = '/savings';
  static const String createSavingsGoal = '/savings/create';

  // Debt Routes
  static const String debts = '/debts';
  static const String createDebt = '/debts/create';
  static const String debtDetail = '/debts/detail';

  // AI & Advanced Features
  static const String aiChat = '/ai/chat';
  static const String insights = '/ai/insights';
  static const String offers = '/offers';
  static const String scanReceipt = '/expense/scan-receipt';
}
