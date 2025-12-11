class AppRoutes {
  // Auth routes
  static const String splashScreen = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpConfirm = '/otp-confirm';
  static const String resetPasswordSendEmail = '/reset-password-send-email';
  static const String resetPasswordConfirmOtp = '/reset-password-confirm-otp';
  static const String resetPasswordFinish = '/reset-password-finish';
  static const String changePassword = '/change-password';

  // Main app routes
  static const String home = '/home';
  static const String analytics = '/analytics';
  static const String analyticsDashboard = '/analytics-dashboard';
  static const String reports = '/reports';
  static const String debts = '/debts';
  static const String savings = '/savings';
  static const String budgets = '/budgets';
  static const String transactions = '/transactions';
  static const String addTransaction = '/add-transaction';
  static const String transactionDetail = '/transaction-detail';
  static const String createDebt = '/create-debt';
  static const String debtDetail = '/debt-detail';
  static const String export = '/export';
  static const String settings = '/settings';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';

  // AI & Insights
  static const String aiChat = '/ai-chat';
  static const String insights = '/insights';

  // Offers
  static const String offers = '/offers';
  static const String offerDetail = '/offer-detail';

  // Shared Budgets
  static const String sharedBudgets = '/shared-budgets';
  static const String createSharedBudget = '/create-shared-budget';
  static const String sharedBudgetDetail = '/shared-budget-detail';
  static const String inviteMembers = '/invite-members';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationSettings = '/notification-settings';

  // Backup
  static const String backup = '/backup';

  AppRoutes._();
}
