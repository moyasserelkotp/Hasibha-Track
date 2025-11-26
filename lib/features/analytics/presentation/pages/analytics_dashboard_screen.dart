import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../blocs/analytics_bloc.dart';
import '../blocs/analytics_event.dart';
import '../blocs/analytics_state.dart';
import '../widgets/spending_trend_chart.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/monthly_comparison_chart.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final now = DateTime.now();
        return di.sl<AnalyticsBloc>()
          ..add(LoadAnalytics(
            startDate: now.subtract(const Duration(days: 30)),
            endDate: now,
          ));
      },
      child: const _AnalyticsDashboardContent(),
    );
  }
}

class _AnalyticsDashboardContent extends StatelessWidget {
  const _AnalyticsDashboardContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AnalyticsBloc>().add(const RefreshAnalytics());
            },
          ),
        ],
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(state.message),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AnalyticsBloc>().add(const RefreshAnalytics());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AnalyticsLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  _buildSummaryCards(state),
                  SizedBox(height: 24.h),

                  // Spending Trend
                  Text(
                    'Spending Trend (Last 30 Days)',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 250.h,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SpendingTrendChart(
                      dailyTrend: state.analytics.dailyTrend,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Category Breakdown
                  Text(
                    'Category Breakdown',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 250.h,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CategoryPieChart(
                      categoryBreakdown: state.analytics.categoryBreakdown,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Monthly Comparison
                  Text(
                    'Monthly Comparison',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 250.h,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: MonthlyComparisonChart(
                      monthlyData: state.monthlyComparison,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSummaryCards(AnalyticsLoaded state) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Total Spent',
            value: '\$${state.analytics.totalSpent.toStringAsFixed(2)}',
            icon: Icons.attach_money,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildSummaryCard(
            title: 'Daily Avg',
            value: '\$${state.analytics.averageDaily.toStringAsFixed(2)}',
            icon: Icons.calendar_today,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: color),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
