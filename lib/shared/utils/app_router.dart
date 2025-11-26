import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hasibha/features/auth/presentation/pages/otp_confirm_screen.dart';
import 'package:hasibha/features/auth/presentation/pages/register_screen.dart';
import 'package:hasibha/features/auth/presentation/pages/reset_password_send_email_screen.dart';
import 'package:hasibha/features/auth/presentation/pages/reset_password_verify_otp_screen.dart';
import 'package:hasibha/features/auth/presentation/pages/reset_password_finish_screen.dart';
import 'package:hasibha/features/home/presentation/pages/home_screen_dashboard.dart';
import 'package:hasibha/features/home/presentation/pages/add_transaction_screen.dart';
import 'package:hasibha/features/home/presentation/pages/analytics_screen.dart';
import 'package:hasibha/shared/pages/export_screen.dart';
import 'package:hasibha/shared/pages/settings_screen.dart';
import 'package:hasibha/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:hasibha/features/splash/presentation/pages/splash_screen.dart';
import 'package:hasibha/shared/utils/routes.dart';

import 'package:hasibha/features/auth/presentation/pages/change_password_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';

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
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpConfirm,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return OtpConfirmScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.resetPasswordSendEmail,
        builder: (context, state) => const ResetPasswordSendEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPasswordConfirmOtp,
        builder: (context, state) {
           final resetToken = state.extra as String?;
           return ResetPasswordVerifyOtpScreen(resetToken: resetToken);
        },
      ),
      GoRoute(
        path: AppRoutes.resetPasswordFinish,
        builder: (context, state) {
           final resetToken = state.extra as String?;
           return ResetPasswordFinishScreen(resetToken: resetToken);
        },
      ),
      // New routes
      GoRoute(
        path: AppRoutes.addTransaction,
        builder: (context, state) {
          final type = state.extra as String?; // 'expense' or 'income'
          return AddTransactionScreen(type: type);
        },
      ),
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) => const AnalyticsScreen(),
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri.toString()}'),
      ),
    ),
  );
}
