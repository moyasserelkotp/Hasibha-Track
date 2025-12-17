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
        // App Bar
        SliverAppBar(
          expandedHeight: 80.h,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeBack,
                  style: AppTextStyles.labelMedium(context).copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  summary.userName ?? 'User',
                  style: AppTextStyles.titleMedium(context),
                ),
              ],
            ),
            titlePadding: EdgeInsets.only(
              left: DesignTokens.space20,
              bottom: DesignTokens.space12,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.push(AppRoutes.notifications);
              },
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined),
                  if (summary.unreadNotifications > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          summary.unreadNotifications > 9
                              ? '9+'
                              : summary.unreadNotifications.toString(),
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                context.push(AppRoutes.profile);
              },
              icon: const Icon(Icons.person_outline),
            ),
            SizedBox(width: DesignTokens.space8),
          ],
        ),

        // Premium Balance Card
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DesignTokens.space16,
              vertical: DesignTokens.space12,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: DesignTokens.borderRadiusXl,
                boxShadow: DesignTokens.coloredShadow(AppColors.primary, opacity: 0.25),
              ),
              padding: EdgeInsets.all(DesignTokens.space20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.totalBalance,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: DesignTokens.textBase,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isBalanceHidden = !_isBalanceHidden;
                          });
                        },
                        child: Icon(
                          _isBalanceHidden 
                              ? Icons.visibility_off_outlined 
                              : Icons.visibility_outlined,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.space8),
                  _isBalanceHidden
                      ? Text(
                          '••••••',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: DesignTokens.text3xl,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : AnimatedCounterText(
                          value: summary.totalBalance,
                          prefix: '\$',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: DesignTokens.text3xl,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(height: DesignTokens.space16),
                  Container(
                    padding: EdgeInsets.all(DesignTokens.space12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: DesignTokens.borderRadiusLg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildBalanceItem(
                            Icons.arrow_downward_rounded,
                            AppStrings.income,
                            summary.monthlyIncome,
                            Colors.white,
                            showTrend: true,
                            trendUp: true,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40.h,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        Expanded(
                          child: _buildBalanceItem(
                            Icons.arrow_upward_rounded,
                            AppStrings.expense,
                            summary.monthlyExpenses,
                            Colors.white,
                            showTrend: true,
                            trendUp: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Quick Actions - Enhanced Grid
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: AppStrings.quickActions,
                  icon: Icons.flash_on_rounded,
                ),
                SizedBox(height: DesignTokens.space16),
                _buildQuickActionsGrid(),
              ],
            ),
          ),
        ),

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
                  child: _buildTransactionCard(transaction),
                );
              },
              childCount: summary.recentTransactions.length,
            ),
          ),

        SliverToBoxAdapter(
          child: SizedBox(height: 100.h), // Space for bottom nav
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

  Widget _buildQuickActionsGrid() {
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.90,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildQuickActionItem(
          action['icon'] as IconData,
          action['label'] as String,
          action['color'] as Color,
          () => context.push(action['route'] as String),
        );
      },
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
      borderRadius: BorderRadius.circular(14.r),
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          boxShadow: DesignTokens.shadowSm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: Colors.white, size: 20.sp),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
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
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        borderRadius: DesignTokens.borderRadiusLg,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.lightbulb_rounded,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: DesignTokens.space12),
          Expanded(
            child: Text(
              insight,
              style: TextStyle(
                fontSize: DesignTokens.textSm,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
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

  Widget _buildTransactionCard(dynamic transaction) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.space12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.borderRadiusMd,
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: _getCategoryColor(transaction.category).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              _getCategoryIcon(transaction.category),
              color: _getCategoryColor(transaction.category),
              size: 24.sp,
            ),
          ),
          SizedBox(width: DesignTokens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: DesignTokens.textBase,
                  ),
                ),
                Text(
                  transaction.category,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: DesignTokens.textSm,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.type == 'expense' ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: DesignTokens.textBase,
              color: transaction.type == 'expense'
                  ? AppColors.error
                  : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color(0xFFFF6B6B);
      case 'transport':
        return const Color(0xFF4ECDC4);
      case 'shopping':
        return const Color(0xFFFFE66D);
      case 'entertainment':
        return const Color(0xFF95E1D3);
      case 'bills':
        return const Color(0xFFF38181);
      case 'health':
        return const Color(0xFF4CAF50);
      default:
        return AppColors.primary;
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
