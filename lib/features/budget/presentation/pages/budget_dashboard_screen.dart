import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/utils/routes.dart';
import '../blocs/budget/budget_bloc.dart';
import '../blocs/budget/budget_event.dart';
import '../blocs/budget/budget_state.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_alert_banner.dart';

class BudgetDashboardScreen extends StatelessWidget {
  const BudgetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BudgetBloc>(
      create: (_) => di.sl<BudgetBloc>()..add(const LoadBudgets()),
      child: const _BudgetDashboardContent(),
    );
  }
}

class _BudgetDashboardContent extends StatelessWidget {
  const _BudgetDashboardContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Budgets'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BudgetBloc>().add(const RefreshBudgets());
            },
          ),
        ],
      ),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BudgetOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BudgetLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading budgets...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          if (state is BudgetLoaded) {
            return Column(
              children: [
                // Alert Banners
                if (state.exceededBudgets.isNotEmpty)
                  BudgetAlertBanner(
                    budgets: state.exceededBudgets,
                    type: AlertType.exceeded,
                  ),
                if (state.approachingBudgets.isNotEmpty)
                  BudgetAlertBanner(
                    budgets: state.approachingBudgets,
                    type: AlertType.approaching,
                  ),

                // Budget List
                Expanded(
                  child: state.budgets.isEmpty
                      ? _buildEmptyState(context)
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            context.read<BudgetBloc>().add(const RefreshBudgets());
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.all(16.w),
                            itemCount: state.budgets.length,
                            itemBuilder: (context, index) {
                              final budget = state.budgets[index];
                              return BudgetCard(
                                budget: budget,
                                index: index,
                                onTap: () {
                                  // Navigate to detail screen
                                },
                                onEdit: () {
                                  context.push(
                                    '${AppRoutes.budgets}/edit/${budget.id}',
                                  );
                                },
                                onDelete: () {
                                  _showDeleteConfirmation(context, budget.id);
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          }

          return _buildEmptyState(context);
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            context.push(AppRoutes.createBudget);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Create Budget', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primaryLight.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 80.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No budgets yet',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Start creating budgets to track your\nspending and stay on target',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.createBudget),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: Text(
                'Create Your First Budget',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Budget'),
        content: const Text('Are you sure you want to delete this budget?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<BudgetBloc>().add(DeleteBudget(id));
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
