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
              SnackBar(content: Text(state.message)),
            );
          } else if (state is BudgetOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is BudgetLoading) {
            return const Center(child: CircularProgressIndicator());
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.createBudget);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Create Budget'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 100.sp,
            color: AppColors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'No budgets yet',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Set spending limits to track your budget',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
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
