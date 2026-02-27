import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/design_tokens.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../blocs/analytics_bloc.dart';
import '../blocs/analytics_event.dart';
import '../blocs/analytics_state.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/spending_trend_chart.dart';
import '../widgets/monthly_comparison_chart.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // String _selectedPeriod = 'Month'; // TODO: Implement period filtering

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AnalyticsBloc>()..add(LoadSpendingAnalytics()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: const Color(0xFF00BFA5),
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Analytics & Insights',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today_rounded, color: Colors.white, size: 20.sp),
              onPressed: () {
                // TODO: Date range picker
              },
            ),
            SizedBox(width: 8.w),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10.w),
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Categories'),
              Tab(text: 'Trends'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AnalyticsError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<AnalyticsBloc>().add(LoadSpendingAnalytics()),
              );
            }

            if (state is AnalyticsLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(state),
                  _buildCategoriesTab(state),
                  _buildTrendsTab(state),
                  _buildReportsTab(state),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildOverviewTab(AnalyticsLoaded state) {
    final analytics = state.analytics;
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnalyticsBloc>().add(LoadSpendingAnalytics());
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Financial Summary Grid
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Spending',
                          '\$${analytics.totalSpending.toStringAsFixed(2)}',
                          const Color(0xFFFF6B6B),
                          Icons.trending_down_rounded,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildSummaryCard(
                          'Total Income',
                          '\$${analytics.totalIncome.toStringAsFixed(2)}',
                          const Color(0xFF4CAF50),
                          Icons.trending_up_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Balance',
                          '\$${(analytics.totalIncome - analytics.totalSpending).toStringAsFixed(2)}',
                          const Color(0xFF00BFA5),
                          Icons.account_balance_wallet_rounded,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildSummaryCard(
                          'Savings Rate',
                          '${analytics.savingsRate.toStringAsFixed(1)}%',
                          const Color(0xFF6495ED),
                          Icons.savings_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Spending by Category Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Text(
                'Spending by Category',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ),
            
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CategoryPieChart(
                categoryData: state.analytics.categoryBreakdown,
              ),
            ),
            
            // Top Spending Categories
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 8.h),
              child: Text(
                'Top Spending Categories',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: analytics.topCategories.take(5).map((category) {
                  return _buildCategoryListItem(category);
                }).toList(),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPills(AnalyticsLoaded state) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      alignment: WrapAlignment.center,
      children: state.analytics.categoryBreakdown.entries.map((entry) {
        final color = _getCategoryColor(entry.key);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getCategoryIcon(entry.key), size: 14.sp, color: color),
              SizedBox(width: 6.w),
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                '${(entry.value / state.analytics.totalSpending * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryListItem(dynamic category) {
    final color = _getCategoryColor(category.categoryName);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(category.categoryName),
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.categoryName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    Text(
                      '\$${category.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Stack(
                  children: [
                    Container(
                      height: 4.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (category.percentage / 100).clamp(0.0, 1.0),
                      child: Container(
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${category.percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab(AnalyticsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnalyticsBloc>().add(LoadSpendingAnalytics());
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildCategoryPills(state),
            ),
            
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 12.h),
              child: Text(
                'Top Spending Categories',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: state.analytics.topCategories.map((category) {
                  return _buildCategoryListItem(category);
                }).toList(),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsTab(AnalyticsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnalyticsBloc>().add(LoadSpendingAnalytics());
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spending Trend
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
              child: Text(
                'Spending Trend',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ),
            
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              height: 250.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.w),
              child: const SpendingTrendChart(),
            ),
            
            // Monthly Comparison
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
              child: Text(
                'Monthly Comparison',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ),
            
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              height: 250.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20.w),
              child: const MonthlyComparisonChart(),
            ),
            
            // Financial Insights
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h),
              child: Text(
                'Financial Insights',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1C1E),
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _buildInsightItem(
                    'Average Daily Spending',
                    '\$${state.analytics.averageDailySpending.toStringAsFixed(2)}',
                    Icons.calendar_today_rounded,
                    const Color(0xFFE0F7F9),
                    const Color(0xFF00BFA5),
                  ),
                  SizedBox(height: 12.h),
                  _buildInsightItem(
                    'Highest Spending Day',
                    state.analytics.highestSpendingDay ?? '2025-12-28',
                    Icons.trending_up_rounded,
                    const Color(0xFFFFF1F1),
                    const Color(0xFFFF6B6B),
                  ),
                  SizedBox(height: 12.h),
                  _buildInsightItem(
                    'Most Frequent Category',
                    state.analytics.mostFrequentCategory ?? 'Food',
                    Icons.category_rounded,
                    const Color(0xFFF3F0FF),
                    const Color(0xFF7C3AED),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String value, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF1A1C1E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String name, double amount, int count) {
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.space12),
      padding: EdgeInsets.all(DesignTokens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.borderRadiusMd,
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: _getCategoryColor(name).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(name),
              color: _getCategoryColor(name),
              size: 24.sp,
            ),
          ),
          SizedBox(width: DesignTokens.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: DesignTokens.textBase,
                  ),
                ),
                Text(
                  '$count transactions',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: DesignTokens.textSm,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: DesignTokens.textLg,
              color: _getCategoryColor(name),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.space12),
      padding: EdgeInsets.all(DesignTokens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.borderRadiusMd,
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: DesignTokens.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: DesignTokens.textSm,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: DesignTokens.textLg,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final categoryLower = category.toLowerCase();
    if (categoryLower.contains('food')) return AppColors.foodColor;
    if (categoryLower.contains('transport')) return AppColors.transportColor;
    if (categoryLower.contains('shopping')) return AppColors.shoppingColor;
    if (categoryLower.contains('entertainment')) return AppColors.entertainmentColor;
    if (categoryLower.contains('health')) return AppColors.healthColor;
    if (categoryLower.contains('bills')) return AppColors.billsColor;
    if (categoryLower.contains('education')) return AppColors.educationColor;
    
    // Fallback to chart colors for unknown categories
    final colors = DesignTokens.chartColors;
    final index = category.hashCode % colors.length;
    return colors[index];
  }

  IconData _getCategoryIcon(String category) {
    final categoryLower = category.toLowerCase();
    if (categoryLower.contains('food')) return Icons.restaurant;
    if (categoryLower.contains('transport')) return Icons.directions_car;
    if (categoryLower.contains('shopping')) return Icons.shopping_bag;
    if (categoryLower.contains('entertainment')) return Icons.movie;
    if (categoryLower.contains('health')) return Icons.local_hospital;
    if (categoryLower.contains('education')) return Icons.school;
    return Icons.category;
  }

  Widget _buildReportsTab(AnalyticsLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(DesignTokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Report Types
          Text(
            'Generate Financial Reports',
            style: TextStyle(
              fontSize: DesignTokens.textXl,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.space16),
          
          // Report Type Cards
          _buildReportTypeCard(
            'Spending Summary',
            'Comprehensive overview of all expenses',
            Icons.receipt_long_rounded,
            AppColors.primary,
          ),
          SizedBox(height: DesignTokens.space12),
          _buildReportTypeCard(
            'Budget Performance',
            'Track budget progress and overspending',
            Icons.account_balance_wallet_rounded,
            AppColors.success,
          ),
          SizedBox(height: DesignTokens.space12),
          _buildReportTypeCard(
            'Category Breakdown',
            'Detailed spending by category',
            Icons.pie_chart_rounded,
            AppColors.secondary,
          ),
          SizedBox(height: DesignTokens.space12),
          _buildReportTypeCard(
            'Savings Progress',
            'Track your savings goals achievement',
            Icons.savings_rounded,
            const Color(0xFF00BFA5),
          ),
          
          SizedBox(height: DesignTokens.space24),
          
          // Export Options
          Text(
            'Export Options',
            style: TextStyle(
              fontSize: DesignTokens.textLg,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.space12),
          Row(
            children: [
              Expanded(
                child: _buildExportOptionCard(
                  'PDF Report',
                  Icons.picture_as_pdf,
                  AppColors.error,
                ),
              ),
              SizedBox(width: DesignTokens.space12),
              Expanded(
                child: _buildExportOptionCard(
                  'CSV Export',
                  Icons.table_chart,
                  AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignTokens.borderRadiusMd,
        boxShadow: DesignTokens.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: DesignTokens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: DesignTokens.textBase,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: DesignTokens.textSm,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildExportOptionCard(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.space20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: DesignTokens.borderRadiusMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40.sp),
          SizedBox(height: DesignTokens.space8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: DesignTokens.textSm,
            ),
          ),
        ],
      ),
    );
  }
}
