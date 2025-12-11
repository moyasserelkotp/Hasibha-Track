import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/const/text_styles.dart';
import '../../../../shared/widgets/common/app_widgets.dart';
import '../../../../shared/widgets/animations/animated_widgets.dart';
import '../cubit/home_cubit.dart';

class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeBack,
                  style: AppTextStyles.labelMedium(context),
                ),
                Text(
                  summary.userName ?? 'User',
                  style: AppTextStyles.titleLarge(context),
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
                Navigator.pushNamed(context, '/notifications');
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
            SizedBox(width: DesignTokens.space8),
          ],
        ),

        // Balance Card
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(DesignTokens.space20),
            child: GlassCard(
              elevation: 8,
              child: Column(
                children: [
                  Text(
                    AppStrings.totalBalance,
                    style: AppTextStyles.labelLarge(context),
                  ),
                  SizedBox(height: DesignTokens.space8),
                  AnimatedCounterText(
                    value: summary.totalBalance,
                    prefix: '\$',
                    style: AppTextStyles.currencyLarge(context),
                  ),
                  SizedBox(height: DesignTokens.space24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBalanceItem(
                          Icons.arrow_downward_rounded,
                          AppStrings.income,
                          summary.monthlyIncome,
                          AppColors.success,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40.h,
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                      Expanded(
                        child: _buildBalanceItem(
                          Icons.arrow_upward_rounded,
                          AppStrings.expense,
                          summary.monthlyExpenses,
                          AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Stats Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.space20),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: AppStrings.budgets,
                    value: summary.activeBudgets.toString(),
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                    subtitle: '${summary.budgetsOnTrack} on track',
                    onTap: () => Navigator.pushNamed(context, '/budgets'),
                  ),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: StatCard(
                    title: AppStrings.savingsGoals,
                    value: summary.savingsGoals.toString(),
                    icon: Icons.savings_rounded,
                    color: AppColors.success,
                    subtitle: '${summary.goalsAchieved} achieved',
                    onTap: () => Navigator.pushNamed(context, '/savings'),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: DesignTokens.space20).toSliver(),

        // Quick Actions
        SliverToBoxAdapter(
          child: SectionHeader(
            title: AppStrings.quickActions,
            icon: Icons.flash_on_rounded,
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: DesignTokens.space20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickAction(
                  Icons.add_circle_rounded,
                  AppStrings.addExpense,
                  AppColors.error,
                  () => Navigator.pushNamed(context, '/add-expense'),
                ),
                _buildQuickAction(
                  Icons.account_balance_wallet_rounded,
                  'Budget',
                  AppColors.primary,
                  () => Navigator.pushNamed(context, '/create-budget'),
                ),
                _buildQuickAction(
                  Icons.savings_rounded,
                  'Save',
                  AppColors.success,
                  () => Navigator.pushNamed(context, '/create-savings-goal'),
                ),
                _buildQuickAction(
                  Icons.receipt_long_rounded,
                  'Scan',
                  AppColors.info,
                  () => Navigator.pushNamed(context, '/scan-receipt'),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: DesignTokens.space24).toSliver(),

        // Recent Transactions
        SliverToBoxAdapter(
          child: SectionHeader(
            title: AppStrings.recentTransactions,
            action: AppStrings.seeAll,
            onActionTap: () => Navigator.pushNamed(context, '/expenses'),
            icon: Icons.history_rounded,
          ),
        ),

        // Transaction List
        if (summary.recentTransactions.isEmpty)
          SliverToBoxAdapter(
            child: EmptyStateWidget(
              icon: Icons.receipt_long_rounded,
              title: AppStrings.noTransactions,
              subtitle: AppStrings.addFirstExpense,
              actionText: AppStrings.addExpense,
              onAction: () => Navigator.pushNamed(context, '/add-expense'),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final transaction = summary.recentTransactions[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: DesignTokens.space20,
                    vertical: DesignTokens.space8,
                  ),
                  child: GlassCard(
                    elevation: 2,
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(transaction.category)
                                .withValues(alpha: 0.1),
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
                                style: AppTextStyles.titleSmall(context),
                              ),
                              Text(
                                transaction.category,
                                style: AppTextStyles.caption(context),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${transaction.amount.toStringAsFixed(2)}',
                          style: AppTextStyles.titleMedium(context).copyWith(
                            color: transaction.type == 'expense'
                                ? AppColors.error
                                : AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: summary.recentTransactions.length,
            ),
          ),

        SliverToBoxAdapter(
          child: SizedBox(height: 100.h),
        ),
      ],
    );
  }

  Widget _buildBalanceItem(
    IconData icon,
    String label,
    double amount,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 4.w),
            Text(label, style: AppTextStyles.labelSmall(context)),
          ],
        ),
        SizedBox(height: 4.h),
        AnimatedCounterText(
          value: amount,
          prefix: '\$',
          style: AppTextStyles.titleMedium(context).copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTextStyles.labelSmall(context),
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
      default:
        return Icons.category_rounded;
    }
  }
}

extension SizedBoxSliver on SizedBox {
  Widget toSliver() => SliverToBoxAdapter(child: this);
}
