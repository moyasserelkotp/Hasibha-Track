import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/const/text_styles.dart';
import '../../../../shared/utils/routes.dart';
import '../../../../shared/widgets/common/app_widgets.dart';
import '../../../../shared/widgets/animations/animated_widgets.dart';
import '../../../../shared/data/mock_data_provider.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  bool _isBalanceHidden = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: FloatingActionButton(
          heroTag: 'home_fab',
          onPressed: () => context.push(AppRoutes.aiChat),
          backgroundColor: const Color(0xFF00BFA5),
          elevation: 4,
          shape: const CircleBorder(),
          child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 28.sp),
        ),
      ),
      body: RefreshIndicator(
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
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: DesignTokens.space16),
          Text(
            AppStrings.loading,
            style: AppTextStyles.bodyMedium(context),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80.sp,
              color: AppColors.error,
            ),
            SizedBox(height: DesignTokens.space24),
            Text(
              message,
              style: AppTextStyles.bodyLarge(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.space24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<HomeCubit>().loadDashboard();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HomeLoaded state) {
    final summary = state.summary;
    final insights = MockDataProvider.getMockAIInsights();
    final upcomingBills = MockDataProvider.getUpcomingBills();
    final sharedBudgets = MockDataProvider.getMockSharedBudgets();
    
    return CustomScrollView(
      slivers: [
        // 1. New Redesigned Header (Welcome Back + Profile Image)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: const Color(0xFF888888),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Mohamed Yaser',
                      style: GoogleFonts.poppins(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00BFA5),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 26.r,
                    backgroundImage: const AssetImage('assets/images/avatar.jpg'),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 2. Refined Balance Card (Precisely matching the mockup)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00BFA5),
                    Color(0xFF009688),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BFA5).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Total Balance Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.totalBalance,
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () => setState(() => _isBalanceHidden = !_isBalanceHidden),
                        child: Icon(
                          _isBalanceHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // Balance Amount
                  Text(
                    _isBalanceHidden ? '••••••' : '\$${summary.totalBalance.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 44.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Integrated White Summary Card
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBalanceSummaryItem(
                          icon: Icons.arrow_upward_rounded,
                          label: 'Income',
                          amount: summary.monthlyIncome,
                          color: const Color(0xFF4CAF50),
                          bgColor: const Color(0xFFE8F5E9),
                        ),
                        Container(
                          width: 1,
                          height: 45.h,
                          color: Colors.grey.withValues(alpha: 0.15),
                        ),
                        _buildBalanceSummaryItem(
                          icon: Icons.arrow_downward_rounded,
                          label: 'Expense',
                          amount: summary.monthlyExpenses,
                          color: const Color(0xFFF44336),
                          bgColor: const Color(0xFFFFEBEE),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 4.h)),

        // Quick Actions - Enhanced Grid
        SliverToBoxAdapter(
          child: FadeSlideTransition(
            delay: const Duration(milliseconds: 400),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
                child: SectionHeader(
                  title: AppStrings.quickActions,
                  icon: Icons.bolt_rounded,
                ),
              ),
          ),
        ),
        
        SliverToBoxAdapter(child: SizedBox(height: DesignTokens.space4)),

        _buildQuickActionsSliver(),

        SizedBox(height: DesignTokens.space16).toSliver(),

        // AI Insights
        if (insights.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
                  child: SectionHeader(
                    title: 'AI Insights',
                    icon: Icons.lightbulb_outline_rounded,
                    action: 'See All',
                    onActionTap: () => context.push(AppRoutes.insights),
                  ),
                ),
                SizedBox(height: DesignTokens.space16),
                _buildInsightsScroll(insights),
              ],
            ),
          ),

        SizedBox(height: DesignTokens.space16).toSliver(),

        // Stats Cards Row
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: AppStrings.budgets,
                    value: summary.activeBudgets?.toString() ?? '0',
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                    subtitle: '${summary.budgetsOnTrack ?? 0} on track',
                    onTap: () => context.push(AppRoutes.budgets),
                  ),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: StatCard(
                    title: AppStrings.savingsGoals,
                    value: summary.savingsGoals?.toString() ?? '0',
                    icon: Icons.savings_rounded,
                    color: AppColors.success,
                    subtitle: '${summary.goalsAchieved ?? 0} achieved',
                    onTap: () => context.push(AppRoutes.savings),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: DesignTokens.space16).toSliver(),

        // Upcoming Bills
        if (upcomingBills.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
                  child: SectionHeader(
                    title: 'Upcoming Bills',
                    icon: Icons.receipt_long_rounded,
                  ),
                ),
                SizedBox(height: DesignTokens.space16),
                _buildUpcomingBills(upcomingBills),
              ],
            ),
          ),

        SizedBox(height: DesignTokens.space16).toSliver(),

        // Shared Budgets Preview
        if (sharedBudgets.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
                  child: SectionHeader(
                    title: 'Shared Budgets',
                    icon: Icons.group_rounded,
                    action: 'See All',
                    onActionTap: () => context.push(AppRoutes.sharedBudgets),
                  ),
                ),
                SizedBox(height: DesignTokens.space16),
                _buildSharedBudgetsPreview(sharedBudgets.take(2).toList()),
              ],
            ),
          ),

        SizedBox(height: DesignTokens.space16).toSliver(),

        // Recent Transactions
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
            child: SectionHeader(
              title: AppStrings.recentTransactions,
              action: AppStrings.seeAll,
              onActionTap: () => context.push(AppRoutes.transactions),
              icon: Icons.history_rounded,
            ),
          ),
        ),

        // Transaction List
        if (summary.recentTransactions.isEmpty)
          SliverToBoxAdapter(
            child: EmptyStateWidget(
              icon: Icons.receipt_long_rounded,
              title: AppStrings.noTransactions,
              subtitle: 'Start tracking your expenses',
              actionText: AppStrings.addExpense,
              onAction: () => context.push(AppRoutes.addTransaction),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final transaction = summary.recentTransactions[index];
                return Padding(
                  padding: EdgeInsets.only(
                    left: DesignTokens.space20,
                    right: DesignTokens.space20,
                    bottom: DesignTokens.space12,
                  ),
                  child: InkWell(
                    onTap: () => _showTransactionDetail(context, transaction),
                    borderRadius: DesignTokens.borderRadiusXl,
                    child: _buildTransactionCard(transaction),
                  ),
                );
              },
              childCount: summary.recentTransactions.length,
            ),
          ),

        SliverToBoxAdapter(
          child: SizedBox(height: 80.h), // Space for bottom nav
        ),
      ],
    );
  }

  Widget _buildBalanceSummaryItem({
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
    required Color bgColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 12.sp, color: color),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'This Month',
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: AppColors.textDisabled,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceItem(
    IconData icon,
    String label,
    double amount,
    Color color, {
    bool showTrend = false,
    bool trendUp = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.9),
                fontSize: DesignTokens.textSm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\$${amount.toStringAsFixed(0)}',
              style: TextStyle(
                color: color,
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showTrend) ...[
              SizedBox(width: 4.w),
              Icon(
                trendUp ? Icons.trending_up : Icons.trending_down,
                size: 16.sp,
                color: color.withValues(alpha: 0.8),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsSliver() {
    final actions = [
      {'icon': Icons.add_circle_rounded, 'label': 'Add\nExpense', 'color': AppColors.error, 'route': AppRoutes.addTransaction},
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'Create\nBudget', 'color': AppColors.primary, 'route': AppRoutes.createBudget},
      {'icon': Icons.savings_rounded, 'label': 'Savings\nGoal', 'color': AppColors.success, 'route': AppRoutes.createSavingsGoal},
      {'icon': Icons.trending_up_rounded, 'label': 'Analytics', 'color': AppColors.info, 'route': AppRoutes.analytics},
      {'icon': Icons.account_balance_rounded, 'label': 'Debt\nTracking', 'color': AppColors.warning, 'route': AppRoutes.debts},
      {'icon': Icons.chat_bubble_outline_rounded, 'label': 'AI\nChat', 'color': AppColors.accentPurple, 'route': AppRoutes.aiChat},
      {'icon': Icons.local_offer_rounded, 'label': 'Offers', 'color': AppColors.secondary, 'route': AppRoutes.offers},
      {'icon': Icons.group_rounded, 'label': 'Shared\nBudgets', 'color': AppColors.accentBlue, 'route': AppRoutes.sharedBudgets},
    ];

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final action = actions[index];
            return FadeSlideTransition(
              delay: Duration(milliseconds: 400 + (index * 50)),
              child: _buildQuickActionItem(
                action['icon'] as IconData,
                action['label'] as String,
                action['color'] as Color,
                () => context.push(action['route'] as String),
              ),
            );
          },
          childCount: actions.length,
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsScroll(List<String> insights) {
    return SizedBox(
      height: 95.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: DesignTokens.space20),
        itemCount: insights.take(4).length,
        itemBuilder: (context, index) {
          return _buildInsightCard(insights[index], index);
        },
      ),
    );
  }

  Widget _buildInsightCard(String insight, int index) {
    final colors = [AppColors.primary, AppColors.success, AppColors.warning, AppColors.info];
    final color = colors[index % colors.length];
    
    return Container(
      width: 260.w,
      margin: EdgeInsets.only(right: DesignTokens.space12),
      padding: EdgeInsets.all(DesignTokens.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.05),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: DesignTokens.borderRadiusXl,
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: DesignTokens.space12),
          Expanded(
            child: Text(
              insight,
              style: TextStyle(
                fontSize: DesignTokens.textSm,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBills(List<Map<String, dynamic>> bills) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.space20),
      child: Column(
        children: bills.take(3).map((bill) {
          final daysUntilDue = (bill['dueDate'] as DateTime).difference(DateTime.now()).inDays;
          final isUrgent = daysUntilDue <= 3;
          final isWarning = daysUntilDue > 3 && daysUntilDue <= 7;
          
          return Container(
            margin: EdgeInsets.only(bottom: DesignTokens.space12),
            padding: EdgeInsets.all(DesignTokens.space16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: DesignTokens.borderRadiusMd,
              boxShadow: DesignTokens.shadowSm,
              border: Border.all(
                color: isUrgent 
                    ? AppColors.error.withValues(alpha: 0.3)
                    : isWarning 
                        ? AppColors.warning.withValues(alpha: 0.3)
                        : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: (isUrgent ? AppColors.error : isWarning ? AppColors.warning : AppColors.info)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: isUrgent ? AppColors.error : isWarning ? AppColors.warning : AppColors.info,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: DesignTokens.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: DesignTokens.textBase,
                        ),
                      ),
                      Text(
                        'Due in $daysUntilDue days',
                        style: TextStyle(
                          color: isUrgent ? AppColors.error : AppColors.textSecondary,
                          fontSize: DesignTokens.textSm,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${bill['amount'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: DesignTokens.textLg,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSharedBudgetsPreview(List<Map<String, dynamic>> budgets) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.space20),
      child: Column(
        children: budgets.map((budget) {
          final progress = budget['totalSpent'] / budget['totalBudget'];
          final members = budget['members'] as List;
          
          return Container(
            margin: EdgeInsets.only(bottom: DesignTokens.space12),
            padding: EdgeInsets.all(DesignTokens.space12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: DesignTokens.borderRadiusMd,
              boxShadow: DesignTokens.shadowSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.group_rounded, color: AppColors.primary, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          budget['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: DesignTokens.textBase,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${budget['totalSpent'].toStringAsFixed(0)} / \$${budget['totalBudget'].toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: DesignTokens.textSm,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DesignTokens.space12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8.h,
                    backgroundColor: AppColors.grey.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation(
                      progress > 0.8 ? AppColors.error : AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: DesignTokens.space12),
                Row(
                  children: [
                    ...members.take(3).map((member) {
                      return Container(
                        width: 32.w,
                        height: 32.w,
                        margin: EdgeInsets.only(right: 4.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            member['avatar'],
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      );
                    }),
                    if (members.length > 3)
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '+${members.length - 3}',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, dynamic transaction) {
    final categoryColor = _getCategoryColor(transaction.category);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.fromLTRB(28.w, 16.h, 28.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: categoryColor,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              transaction.title,
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              transaction.category,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              '${transaction.type == 'expense' ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 36.sp,
                fontWeight: FontWeight.w800,
                color: transaction.type == 'expense' ? AppColors.error : AppColors.success,
              ),
            ),
            SizedBox(height: 32.h),
            _buildDetailInfoRow(Icons.calendar_today_rounded, 'Date', 
                '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}'),
            SizedBox(height: 16.h),
            _buildDetailInfoRow(Icons.description_outlined, 'Description', 
                transaction.description ?? 'No description provided'),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F3F4),
                foregroundColor: AppColors.textPrimary,
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.textSecondary),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textDisabled,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionCard(dynamic transaction) {
    final categoryColor = _getCategoryColor(transaction.category);
    
    return FadeSlideTransition(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: EdgeInsets.all(DesignTokens.space16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              categoryColor.withValues(alpha: 0.01),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: DesignTokens.borderRadiusXl,
          border: Border.all(
            color: categoryColor.withValues(alpha: 0.12),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(13.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    categoryColor.withValues(alpha: 0.15),
                    categoryColor.withValues(alpha: 0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: categoryColor,
                size: 28.sp,
              ),
            ),
            SizedBox(width: DesignTokens.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: DesignTokens.textLg,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          transaction.category,
                          style: TextStyle(
                            color: categoryColor,
                            fontSize: DesignTokens.textXs,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.type == 'expense' ? '-' : '+'}\ \$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: DesignTokens.textLg,
                    color: transaction.type == 'expense'
                        ? AppColors.error
                        : AppColors.success,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textDisabled.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Today', 
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: DesignTokens.textXs,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return AppColors.foodColor;
      case 'transport':
        return AppColors.transportColor;
      case 'shopping':
        return AppColors.shoppingColor;
      case 'entertainment':
        return AppColors.entertainmentColor;
      case 'bills':
        return AppColors.billsColor;
      case 'health':
        return AppColors.healthColor;
      case 'education':
        return AppColors.educationColor;
      default:
        return AppColors.othersColor;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'health':
        return Icons.local_hospital_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}

extension SizedBoxSliver on SizedBox {
  Widget toSliver() => SliverToBoxAdapter(child: this);
}
