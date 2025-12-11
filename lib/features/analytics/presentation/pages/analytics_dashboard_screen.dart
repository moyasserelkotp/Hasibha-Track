import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
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
  String _selectedPeriod = 'Month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          title: const Text('Analytics & Insights'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.date_range),
              onSelected: (value) {
                setState(() => _selectedPeriod = value);
                context.read<AnalyticsBloc>().add(LoadSpendingAnalytics());
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'Week', child: Text('This Week')),
                const PopupMenuItem(value: 'Month', child: Text('This Month')),
                const PopupMenuItem(value: 'Quarter', child: Text('This Quarter')),
                const PopupMenuItem(value: 'Year', child: Text('This Year')),
              ],
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Categories'),
              Tab(text: 'Trends'),
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
        padding: EdgeInsets.all(DesignTokens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Financial Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Spending',
                    '\$${analytics.totalSpending.toStringAsFixed(2)}',
                    AppColors.error,
                    Icons.trending_down,
                  ),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Income',
                    '\$${analytics.totalIncome.toStringAsFixed(2)}',
                    AppColors.success,
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: DesignTokens.space12),
            
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Balance',
                    '\$${(analytics.totalIncome - analytics.totalSpending).toStringAsFixed(2)}',
                    AppColors.primary,
                    Icons.account_balance_wallet,
                  ),
                ),
                SizedBox(width: DesignTokens.space12),
                Expanded(
                  child: _buildSummaryCard(
                    'Savings Rate',
                    '${analytics.savingsRate.toStringAsFixed(1)}%',
                    AppColors.info,
                    Icons.savings,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: DesignTokens.space24),
            
            // Spending by Category
            Text(
              'Spending by Category',
              style: TextStyle(
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space16),
            
            Container(
              height: 300.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: DesignTokens.borderRadiusLg,
                boxShadow: DesignTokens.shadowMd,
              ),
              padding: EdgeInsets.all(DesignTokens.space16),
              child: const CategoryPieChart(),
            ),
            
            SizedBox(height: DesignTokens.space24),
            
            // Top Categories
            Text(
              'Top Spending Categories',
              style: TextStyle(
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space12),
            
            ...analytics.topCategories.take(5).map((category) {
              final percentage = (category['amount'] / analytics.totalSpending * 100);
              return Container(
                margin: EdgeInsets.only(bottom: DesignTokens.space8),
                padding: EdgeInsets.all(DesignTokens.space12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: DesignTokens.borderRadiusMd,
                  boxShadow: DesignTokens.shadowSm,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category['name']).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getCategoryIcon(category['name']),
                        color: _getCategoryColor(category['name']),
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: DesignTokens.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: DesignTokens.textBase,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation(
                              _getCategoryColor(category['name']),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: DesignTokens.space12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${category['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: DesignTokens.textBase,
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: DesignTokens.textSm,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab(AnalyticsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnalyticsBloc>().add(LoadCategoryBreakdown());
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Pie Chart
            Container(
              height: 300.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: DesignTokens.borderRadiusLg,
                boxShadow: DesignTokens.shadowMd,
              ),
              padding: EdgeInsets.all(DesignTokens.space16),
              child: const CategoryPieChart(),
            ),
            
            SizedBox(height: DesignTokens.space24),
            
            Text(
              'Category Details',
              style: TextStyle(
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space16),
            
            // Detailed Category List
            ...state.analytics.topCategories.map((category) {
              return _buildCategoryCard(
                category['name'],
                category['amount'],
                category['count'],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsTab(AnalyticsLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AnalyticsBloc>().add(LoadMonthlyComparison());
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spending Trend Chart
            Text(
              'Spending Trend',
              style: TextStyle(
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space16),
            
            Container(
              height: 250.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: DesignTokens.borderRadiusLg,
                boxShadow: DesignTokens.shadowMd,
              ),
              padding: EdgeInsets.all(DesignTokens.space16),
              child: const SpendingTrendChart(),
            ),
            
            SizedBox(height: DesignTokens.space24),
            
            // Monthly Comparison
            Text(
              'Monthly Comparison',
              style: TextStyle(
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space16),
            
            Container(
              height: 250.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: DesignTokens.borderRadiusLg,
                boxShadow: DesignTokens.shadowMd,
              ),
              padding: EdgeInsets.all(DesignTokens.space16),
              child: const MonthlyComparisonChart(),
            ),
            
            SizedBox(height: DesignTokens.space24),
            
            // Insights
            Text(
              'Financial Insights',
              style: TextStyle(
                fontSize: DesignTokens.textXl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: DesignTokens.space12),
            
            _buildInsightCard(
              'Average Daily Spending',
              '\$${state.analytics.averageDailySpending.toStringAsFixed(2)}',
              Icons.calendar_today,
              AppColors.primary,
            ),
            
            _buildInsightCard(
              'Highest Spending Day',
              state.analytics.highestSpendingDay,
              Icons.trending_up,
              AppColors.error,
            ),
            
            _buildInsightCard(
              'Most Frequent Category',
              state.analytics.mostFrequentCategory,
              Icons.category,
              AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: DesignTokens.borderRadiusLg,
        boxShadow: DesignTokens.coloredShadow(color, opacity: 0.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(height: DesignTokens.space8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: DesignTokens.text2xl,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: DesignTokens.textSm,
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
}
