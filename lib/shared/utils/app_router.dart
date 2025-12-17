import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hasibha/features/auth/presentation/pages/register_screen.dart';
import 'package:hasibha/features/auth/presentation/pages/reset_password_send_email_screen.dart';
import 'package:hasibha/features/auth/presentation/pages/reset_password_finish_screen.dart';
import 'package:hasibha/features/home/presentation/pages/home_screen_dashboard.dart';
import 'package:hasibha/shared/pages/main_shell.dart';
import 'package:hasibha/shared/pages/export_screen.dart';
import 'package:hasibha/shared/pages/settings_screen.dart';
import 'package:hasibha/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:hasibha/features/splash/presentation/pages/splash_screen.dart';
import 'package:hasibha/shared/utils/routes.dart';

import 'package:hasibha/features/auth/presentation/pages/change_password_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/debt/presentation/pages/create_debt_screen.dart';
import '../../features/debt/presentation/pages/debt_detail_screen.dart';
import '../../features/debt/domain/entities/debt.dart';
import '../../features/ai_assistant/presentation/pages/ai_chat_screen.dart';
import '../../features/ai_assistant/presentation/pages/insights_screen.dart';
import '../../features/offers/presentation/pages/offers_screen.dart';
import '../../features/expense/presentation/pages/add_expense_screen.dart';
import '../../features/analytics/presentation/pages/analytics_dashboard_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/notifications/presentation/pages/notification_settings_screen.dart';
import '../../features/shared_budget/presentation/pages/shared_budgets_screen.dart';
import '../../features/analytics/presentation/pages/reports_screen.dart';
import '../../features/budget/presentation/pages/budget_dashboard_screen.dart';
import '../../features/budget/presentation/pages/create_budget_screen.dart';
import '../../features/savings/presentation/pages/savings_dashboard_screen.dart';
import '../../features/savings/presentation/pages/create_savings_goal_screen.dart';
import '../../features/expense/presentation/pages/expense_list_screen.dart';
import '../../features/debt/presentation/pages/debt_dashboard_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) =>  OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen2(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShell(),
      ),
      /*
      GoRoute(
        path: AppRoutes.otpConfirm,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return OtpConfirmScreen(email: email);
        },
      ),
      */
      GoRoute(
        path: AppRoutes.resetPasswordSendEmail,
        builder: (context, state) => const ResetPasswordSendEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPasswordConfirmOtp,
        builder: (context, state) {
           final email = state.extra as String?;
           // Reuse finish screen which now handles code entry
           return ResetPasswordFinishScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.resetPasswordFinish,
        builder: (context, state) {
           final email = state.extra as String?;
           return ResetPasswordFinishScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.addTransaction,
        builder: (context, state) {
          String? initialImagePath;
          
          if (state.extra is Map) {
            final map = state.extra as Map;
            initialImagePath = map['initialImagePath'] as String?;
          }
          
          return AddExpenseScreen(
            initialImagePath: initialImagePath,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createDebt,
        builder: (context, state) {
          final debt = state.extra as Debt?;
          return CreateDebtScreen(debt: debt);
        },
      ),
      GoRoute(
        path: AppRoutes.budgets,
        builder: (context, state) => const BudgetDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.createBudget,
        builder: (context, state) => const CreateBudgetScreen(),
      ),
      GoRoute(
        path: AppRoutes.savings,
        builder: (context, state) => const SavingsDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.createSavingsGoal,
        builder: (context, state) => const CreateSavingsGoalScreen(),
      ),
      GoRoute(
        path: AppRoutes.transactions,
        builder: (context, state) => const ExpenseListScreen(),
      ),
      GoRoute(
        path: AppRoutes.debts,
        builder: (context, state) => const DebtDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.debtDetail,
        builder: (context, state) {
          final debt = state.extra as Debt;
          return DebtDetailScreen(debt: debt);
        },
      ),
      GoRoute(
        path: AppRoutes.export,
        builder: (context, state) => const ExportScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiChat,
        builder: (context, state) => const AiChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.insights,
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) => const AnalyticsDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.analyticsDashboard,
        builder: (context, state) => const AnalyticsDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.offers,
        builder: (context, state) => const OffersScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.sharedBudgets,
        builder: (context, state) => const SharedBudgetsScreen(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (context, state) => const ReportsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri.toString()}'),
      ),
    ),
  );
}
