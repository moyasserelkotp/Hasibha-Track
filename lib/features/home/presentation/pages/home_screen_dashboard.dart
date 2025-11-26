import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/utils/feature_flags.dart';
import '../../../../shared/widgets/animations/animations.dart';

import '../../../../di/injection.dart' as di;
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth/auth_event.dart';
import '../../../auth/presentation/blocs/auth/auth_state.dart';
import '../cubit/home_cubit.dart';
import '../../../../shared/utils/routes.dart';
import '../cubit/home_state.dart';
import '../widgets/financial_summary_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/transaction_list_item.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../../../shared/widgets/empty/empty_state.dart';
import '../../../../shared/widgets/error/error_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HomeCubit>()..loadDashboardData(),
      child: PopScope(
        canPop: false, // Prevent back navigation from home - use logout instead
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              // Navigate to login and remove all previous routes
              context.go(AppRoutes.login);
            }
          },
          child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.welcomeBack,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () {
                // TODO: Handle notifications
              },
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.account_circle_outlined, color: Theme.of(context).colorScheme.onSurface),
              onSelected: (value) {
                if (value == 'logout') {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                } else if (value == 'profile') {
                  // Profile screen not implemented yet
                  AppSnackBar.showInfo(
                    context,
                    message: 'Profile feature coming soon!',
                  );
                } else if (value == 'change_password') {
                  context.push(AppRoutes.changePassword);
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person_outline),
                      SizedBox(width: 8),
                      Text(AppStrings.profile),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'change_password',
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline),
                      SizedBox(width: 8),
                      Text(AppStrings.changePassword),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: AppColors.error),
                      SizedBox(width: 8),
                      Text(AppStrings.logout, style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return _buildShimmerLoading();
            }

            if (state is HomeError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<HomeCubit>().refreshDashboard(),
              );
            }

            if (state is HomeLoaded) {
              final summary = state.dashboardSummary;
              
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeCubit>().refreshDashboard();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Financial Summary Card with animation
                      FadeSlideAnimation(
                        duration: Duration(milliseconds: 600),
                        slideBegin: Offset(0, 0.3),
                        child: FinancialSummaryCard(
                          totalBalance: summary.totalBalance,
                          income: summary.totalIncome,
                          expense: summary.totalExpense,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Quick Actions
                      Text(
                        AppStrings.quickActions,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: QuickActionButton(
                              icon: Icons.add,
                              label: AppStrings.addExpense,
                              color: AppColors.error,
                              onTap: () async {
                                if (FeatureFlags.isFeatureEnabled(Feature.addExpense)) {
                                  final result = await context.push(AppRoutes.addTransaction, extra: 'expense');
                                  if (result == true) {
                                    // Refresh dashboard after adding transaction
                                    context.read<HomeCubit>().refreshDashboard();
                                  }
                                } else {
                                  FeatureFlags.handleFeatureNotAvailable(context, Feature.addExpense);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: QuickActionButton(
                              icon: Icons.add,
                              label: AppStrings.addIncome,
                              color: AppColors.success,
                              onTap: () async {
                                if (FeatureFlags.isFeatureEnabled(Feature.addIncome)) {
                                  final result = await context.push(AppRoutes.addTransaction, extra: 'income');
                                  if (result == true) {
                                    // Refresh dashboard after adding transaction
                                    context.read<HomeCubit>().refreshDashboard();
                                  }
                                } else {
                                  FeatureFlags.handleFeatureNotAvailable(context, Feature.addIncome);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: QuickActionButton(
                              icon: Icons.trending_up,
                              label: AppStrings.analytics,
                              color: AppColors.primary,
                              onTap: () {
                                if (FeatureFlags.isFeatureEnabled(Feature.analytics)) {
                                  context.push(AppRoutes.analytics);
                                } else {
                                  FeatureFlags.handleFeatureNotAvailable(context, Feature.analytics);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      
                      // Second row of quick actions
                      Row(
                        children: [
                          Expanded(
                            child: QuickActionButton(
                              icon: Icons.download,
                              label: 'Export',
                              color: AppColors.info,
                              onTap: () => context.push(AppRoutes.export),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: QuickActionButton(
                              icon: Icons.settings,
                              label: 'Settings',
                              color: AppColors.secondary,
                              onTap: () => context.push(AppRoutes.settings),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Empty space for symmetry
                          Expanded(child: SizedBox()),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Recent Transactions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.recentTransactions,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Navigate to all transactions
                            },
                            child: Text(AppStrings.seeAll, style: TextStyle(color: AppColors.primary, fontSize: 14.sp)),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      
                      if (summary.recentTransactions.isEmpty)
                        EmptyState(
                          title: AppStrings.noTransactions,
                          icon: Icons.receipt_long_outlined,
                        )
                      else
                        ...summary.recentTransactions.asMap().entries.map(
                          (entry) {
                            final index = entry.key;
                            final transaction = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: StaggeredListAnimation(
                                index: index,
                                child: TransactionListItem(
                                  transaction: transaction,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer for financial card
          ShimmerLoading(
            child: Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          
          // Shimmer for quick actions
          ShimmerLoading(
            child: Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: Container(
                    height: 100.h,
                    margin: EdgeInsets.only(right: index < 2 ? 12.w : 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          
          // Shimmer for transactions
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: ShimmerLoading(
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
