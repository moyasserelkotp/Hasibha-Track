import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback
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
import '../../../../shared/widgets/loading/shimmer_loading.dart';
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
            HapticFeedback.mediumImpact(); // Haptic feedback on refresh
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
    return const HomeSkeleton();
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

        // Premium Balance Card - Modern Enhanced Design
        SliverToBoxAdapter(
          child: FadeSlideTransition(
            delay: const Duration(milliseconds: 200),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DesignTokens.space16,
                vertical: DesignTokens.space12,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00D9A3),
                          Color(0xFF00BFA5),
                          Color(0xFF00ACC1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.0, 0.5, 1.0],
                      ),
                      borderRadius: DesignTokens.borderRadius2xl,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00BFA5).withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(DesignTokens.space24),
                    child: Column(
                      children: [
                        Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.totalBalance,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: DesignTokens.textLg,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isBalanceHidden = !_isBalanceHidden;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            _isBalanceHidden 
                                ? Icons.visibility_off_outlined 
                                : Icons.visibility_outlined,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: DesignTokens.space12),
                  _isBalanceHidden
                      ? Text(
                          '••••••',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: DesignTokens.text4xl,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        )
                      : AnimatedCounterText(
                          value: summary.totalBalance,
                          prefix: '\$',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: DesignTokens.text4xl,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                  SizedBox(height: DesignTokens.space20),
                  Container(
                    padding: EdgeInsets.all(DesignTokens.space16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: DesignTokens.borderRadiusXl,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1,
                      ),
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
                          width: 1.5,
                          height: 45.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.4),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
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
              ]),
            ),
                  // Enhanced decorative background circles
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.06),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Additional small accent circle
                  Positioned(
                    top: 50,
                    left: 30,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Quick Actions - Enhanced Grid
        SliverToBoxAdapter(
          child: FadeSlideTransition(
            delay: const Duration(milliseconds: 400),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: DesignTokens.space12),
              child: SectionHeader(
                title: AppStrings.quickActions,
                icon: Icons.flash_on_rounded,
              ),
            ),
          ),
        ),
        
        SliverToBoxAdapter(child: SizedBox(height: DesignTokens.space16)),

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
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 0.8,
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
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: color.withValues(alpha: 0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.15),
                    color.withValues(alpha: 0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                  letterSpacing: -0.2,
                ),
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
