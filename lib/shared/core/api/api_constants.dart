class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://167.71.92.176:8000';
  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl = '$baseUrl$apiVersion';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String resetPasswordEmail = '/auth/reset-password-email';
  static const String resetPasswordVerifyOtp = '/auth/reset-password-verify-otp';
  static const String resetPasswordFinish = '/auth/reset-password-finish';
  static const String changePassword = '/auth/change-password';
  static const String googleAuth = '/auth/google';


  // Transaction Endpoints
  static const String transactions = '/transactions';
  static const String transactionById = '/transactions/{id}';
  static const String recentTransactions = '/transactions/recent';
  static const String transactionsByCategory = '/transactions/category/{categoryId}';

  // Dashboard Endpoints
  static const String dashboardSummary = '/dashboard/summary';
  static const String monthlyReport = '/dashboard/monthly-report';

  // Budget Endpoints
  static const String budgets = '/budgets';
  static const String budgetById = '/budgets/{id}';
  static const String monthlyBudget = '/budgets/monthly';

  // Category Endpoints
  static const String categories = '/categories';
  static const String categoryById = '/categories/{id}';

  // Goals Endpoints
  static const String goals = '/goals';
  static const String goalById = '/goals/{id}';

  // Shared Budget Endpoints
  static const String sharedBudgets = '/shared-budgets';
  static const String sharedBudgetById = '/shared-budgets/{id}';
  static const String sharedBudgetMembers = '/shared-budgets/{id}/members';

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
