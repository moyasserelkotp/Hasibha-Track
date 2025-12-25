import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/const/text_styles.dart';
import '../../../../shared/widgets/animations/animated_counter.dart';
import '../../../../shared/widgets/indicators/progress_ring.dart';
import '../../../../shared/widgets/buttons/quick_action_button.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

import '../widgets/transaction_list_item.dart';
import '../../domain/entities/transaction.dart';

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<HomeCubit>().loadDashboard();
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return _buildLoading();
              }

              if (state is HomeError) {
                return _buildError(state.message);
              }

              if (state is HomeLoaded) {
                return _buildContent(state);
              }

              return _buildLoading();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
          SizedBox(height: 16.h),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().loadDashboard(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(HomeLoaded state) {
    final summary = state.summary;

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 120.h,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Welcome Back, ${summary.userName?.split(' ').first ?? 'Friend'}!',
              style: AppTextStyles.titleLarge(context),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          ],
        ),

        // Balance Card with Gradient
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: DesignTokens.heroGradientDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isBalanceVisible = !_isBalanceVisible;
                          });
                        },
                        icon: Icon(
                          _isBalanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 20.sp,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _isBalanceVisible
                      ? AnimatedCounter(
                          value: summary.totalBalance,
                          prefix: '\$',
                          style: TextStyle(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                        )
                      : Text(
                          '\$ ****',
                          style: TextStyle(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: -1,
                          ),
                        ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBalanceItem(
                          Icons.arrow_downward_rounded,
                          'Income',
                          summary.monthlyIncome,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40.h,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      Expanded(
                        child: _buildBalanceItem(
                          Icons.arrow_upward_rounded,
                          'Expense',
                          summary.monthlyExpenses,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Budget Progress Ring
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: DesignTokens.shadowMd,
              ),
              child: Row(
                children: [
                  ProgressRing(
                    progress: (summary.monthlyExpenses / (summary.monthlyIncome + 1)),
                    size: 100,
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Budget',
                          style: AppTextStyles.labelMedium(context),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '\$${(summary.monthlyIncome - summary.monthlyExpenses).toStringAsFixed(2)}',
                          style: AppTextStyles.headlineMedium(context),
                        ),
                        Text(
                          'remaining',
                          style: AppTextStyles.caption(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 26.h).toSliver(),

        // Quick Actions Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(Icons.flash_on_rounded, color: AppColors.primary, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Quick Actions',
                  style: AppTextStyles.titleLarge(context),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 24.h).toSliver(),

        // Quick Actions Grid
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuickActionButton(
                  icon: Icons.add_circle_rounded,
                  label: 'Add Expense',
                  gradient: DesignTokens.expenseGradient,
                  onTap: () => Navigator.pushNamed(context, '/add-expense'),
                ),
                QuickActionButton(
                  icon: Icons.savings_rounded,
                  label: 'Save Money',
                  gradient: DesignTokens.savingsGradient,
                  onTap: () => Navigator.pushNamed(context, '/savings'),
                ),
                QuickActionButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scan Receipt',
                  gradient: DesignTokens.scanGradient,
                  onTap: () {},
                ),
                QuickActionButton(
                  icon: Icons.groups_rounded,
                  label: 'Shared',
                  gradient: DesignTokens.sharedBudgetGradient,
                  onTap: () => Navigator.pushNamed(context, '/shared-budgets'),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 30.h).toSliver(),



        SizedBox(height: 24.h).toSliver(),

        // AI Insight Card
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _buildAiInsightCard(),
          ),
        ),

        SizedBox(height: 30.h).toSliver(),

        // Recent Transactions Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history_rounded, color: AppColors.primary, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Recent Activity',
                      style: AppTextStyles.titleLarge(context),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {}, // Navigate to full history
                  child: Text('View All', style: AppTextStyles.labelLarge(context)),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16.h).toSliver(),

        // Recent Transactions List
        if (summary.recentTransactions.isEmpty)
          const SliverToBoxAdapter(
            child: Center(child: Text("No recent transactions")),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final transaction = summary.recentTransactions[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: TransactionListItem(transaction: transaction),
                  );
                },
                childCount: summary.recentTransactions.length > 5 
                    ? 5 
                    : summary.recentTransactions.length,
              ),
            ),
          ),

        SizedBox(height: 100.h).toSliver(),
      ],
    );
  }

  Widget _buildAiInsightCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade900,
            Colors.deepPurple.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_rounded, color: Colors.amberAccent, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spending Insight',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Your spending on "Food" is 15% lower than last week. Great job!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(IconData icon, String label, double amount) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: Colors.white.withValues(alpha: 0.9)),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

extension SizedBoxSliver on SizedBox {
  Widget toSliver() => SliverToBoxAdapter(child: this);
}
