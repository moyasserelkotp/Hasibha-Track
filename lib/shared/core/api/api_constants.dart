class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://192.168.1.7:3210';
  static const String apiVersion = '/api';
  static const String apiBaseUrl = '$baseUrl$apiVersion';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String signupPhone = '/auth/signup-phone';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String googleSignIn = '/auth/google-signin';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String authMe = '/auth/me';
  static const String profile = '/profile';
  
  // SMS Verification Endpoints
  static const String smsSend = '/auth/sms/send';
  static const String smsVerify = '/auth/sms/verify';
  
  // Security & 2FA Endpoints
  static const String setup2fa = '/security/2fa/setup';
  static const String verify2fa = '/security/2fa/verify';
  static const String status2fa = '/security/2fa/status';
  static const String disable2fa = '/security/2fa/disable';
  static const String devices = '/security/devices';
  static const String deviceTrust = '/security/devices/{deviceId}/trust';
  static const String deviceRemove = '/security/devices/{deviceId}';

  // Deprecated endpoints - kept for reference, remove after migration
  @Deprecated('Use signup instead')
  static const String register = '/auth/register';
  @Deprecated('Use forgotPassword and resetPassword flow')
  static const String resetPasswordEmail = '/auth/reset-password-email';
  @Deprecated('No longer used in new API')
  static const String verifyOtp = '/auth/verify-otp';
  @Deprecated('No longer used in new API')
  static const String resendOtp = '/auth/resend-otp';
  @Deprecated('No longer used in new API')
  static const String resetPasswordVerifyOtp = '/auth/reset-password-verify-otp';
  @Deprecated('No longer used in new API')
  static const String resetPasswordFinish = '/auth/reset-password-finish';
  @Deprecated('Use changePassword instead')
  static const String oldChangePassword = '/auth/change-password';
  static const String changePassword = '/security/change-password';
  @Deprecated('Use googleSignIn instead')
  static const String googleAuth = '/auth/google';


  // Transaction Endpoints
  static const String transactions = '/transactions';
  static const String transactionById = '/transactions'; // Base for /:id
  static const String recentTransactions = '/transactions/recent';
  static const String transactionsByCategory = '/transactions/category/{categoryId}';

  // Expense Endpoints
  static const String expenses = '/expenses';
  static const String expenseById = '/expenses/{id}';
  static const String expensesByCategory = '/expenses/category/{categoryId}';
  static const String expensesByDateRange = '/expenses/date-range';
  static const String expensesImportImage = '/expenses/import/image';
  static const String expenseStats = '/expenses/stats';

  // Dashboard Endpoints
  static const String dashboard = '/dashboard';
  static const String dashboardSummary = '/dashboard';
  static const String monthlyReport = '/dashboard/monthly-report';

  // Budget Endpoints
  static const String budgets = '/budgets';
  static const String budgetById = '/budgets/{id}';
  static const String budgetByCategory = '/budgets/category/{categoryId}';
  static const String budgetExceeded = '/budgets/exceeded';
  static const String budgetApproaching = '/budgets/approaching';

  // Category Endpoints
  static const String categories = '/categories';
  static const String categoryById = '/categories/{id}';

  // Analytics Endpoints
  static const String analyticsSpending = '/analytics/spending';
  static const String analyticsCategories = '/analytics/categories';
  static const String analyticsMonthly = '/analytics/monthly';
  static const String analyticsTrend = '/analytics/trend';

  // Savings Goals Endpoints
  static const String savingsGoals = '/savings-goals';
  static const String savingsGoalById = '/savings-goals/{id}';
  static const String savingsGoalAddFunds = '/savings-goals/{id}/add-funds';
  static const String savingsGoalWithdraw = '/savings-goals/{id}/withdraw';
  static const String goals = '/goals';
  static const String goalById = '/goals/{id}';

  // Shared Budget Endpoints
  static const String sharedBudgets = '/shared-budgets';
  static const String sharedBudgetById = '/shared-budgets/{id}';
  static const String sharedBudgetMembers = '/shared-budgets/{id}/members';

  // Debt Endpoints
  static const String debts = '/debts';
  static const String debtById = '/debts/{id}';
  static const String debtPayments = '/debts/{id}/payments';
  static const String debtSummary = '/debts/summary';

  // HTTP Headers
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String accept = 'Accept';

  // Header Values
  static const String applicationJson = 'application/json';
  static const String bearer = 'Bearer';

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
