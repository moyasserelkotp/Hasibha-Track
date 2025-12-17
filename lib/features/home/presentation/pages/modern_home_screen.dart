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

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {
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
              'Welcome Back!',
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
                      Icon(
                        Icons.visibility_outlined,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 20.sp,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  AnimatedCounter(
                    value: summary.totalBalance,
                    prefix: '\$',
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

        SizedBox(height: 24.h).toSliver(),

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

        SizedBox(height: 16.h).toSliver(),

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

        SizedBox(height: 24.h).toSliver(),

        // AI Insight Card
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: DesignTokens.aiGradientDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Insight',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Your spending is on track this month!',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16.sp),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 100.h).toSliver(),
      ],
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
