import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/widgets/animations/animated_counter.dart';
import '../../../../shared/utils/routes.dart';
import '../blocs/savings_bloc.dart';
import '../blocs/savings_event.dart';
import '../blocs/savings_state.dart';
import '../widgets/savings_goal_card.dart';

class SavingsDashboardScreen extends StatelessWidget {
  const SavingsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SavingsBloc>(
      create: (_) => di.sl<SavingsBloc>()..add(const LoadSavingsGoals()),
      child: const _SavingsDashboardContent(),
    );
  }
}

class _SavingsDashboardContent extends StatelessWidget {
  const _SavingsDashboardContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Savings Goals'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocConsumer<SavingsBloc, SavingsState>(
        listener: (context, state) {
          if (state is SavingsOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is SavingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is SavingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavingsLoaded) {
            if (state.goals.isEmpty) {
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
                              AppColors.success.withValues(alpha: 0.1),
                              const Color(0xFF00BFA5).withValues(alpha: 0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.savings_outlined,
                          size: 80.sp,
                          color: AppColors.success,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Start Saving Today',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Create your first savings goal and\nstart building your financial future',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      ElevatedButton.icon(
                        onPressed: () => context.push(AppRoutes.createSavingsGoal),
                        icon: const Icon(Icons.add_rounded),
                        label: Text(
                          'Create Savings Goal',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                       ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Savings Summary - Enhanced
                  Container(
                    padding: EdgeInsets.all(28.w),
                    decoration: DesignTokens.savingsGradientDecoration(
                      shadows: [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Saved',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.95),
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${state.goals.length} Goals',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        AnimatedCounter(
                          value: state.totalSaved,
                          prefix: '\$',
                          style: TextStyle(
                            fontSize: 44.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              size: 18.sp,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Keep up the great work!',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Goals List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Goals',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => context.push(AppRoutes.createSavingsGoal),
                       icon: Icon(Icons.add_circle_outline, size: 20.sp),
                        label: const Text('Add Goal'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ...state.goals.map((goal) => SavingsGoalCard(
                        goal: goal,
                        onTap: () {
                          // Navigate to detail
                        },
                        onAddFunds: () {
                          _showAddFundsDialog(context, goal.id);
                        },
                      )),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.success, const Color(0xFF00BFA5)],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.createSavingsGoal),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  void _showAddFundsDialog(BuildContext context, String goalId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Funds'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                context.read<SavingsBloc>().add(
                      AddFundsToGoal(id: goalId, amount: amount),
                    );
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
