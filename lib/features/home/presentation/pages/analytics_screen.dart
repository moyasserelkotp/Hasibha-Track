import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/widgets/animations/animations.dart';
import '../../../../shared/widgets/error/error_view.dart';
import '../../../../shared/utils/helpers/currency_helper.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';
import '../widgets/spending_pie_chart.dart';
import '../widgets/trend_bar_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AnalyticsCubit>()..loadAnalytics(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            AppStrings.analytics,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is AnalyticsError) {
              return ErrorView(
                message: state.message,
                onRetry: () => context.read<AnalyticsCubit>().refresh(),
              );
            }

            if (state is AnalyticsLoaded) {
              final data = state.data;

              return RefreshIndicator(
                onRefresh: () => context.read<AnalyticsCubit>().refresh(),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Range Filter
                      FadeSlideAnimation(
                        delay: Duration(milliseconds: 50),
                        child: _buildDateRangeFilter(context),
                      ),
                      SizedBox(height: 16.h),

                      // Monthly Overview Cards
                      FadeSlideAnimation(
                        delay: Duration(milliseconds: 100),
                        child: _buildMonthlyOverview(context, data),
                      ),
                      SizedBox(height: 24.h),

                      // Spending by Category
                      FadeSlideAnimation(
                        delay: Duration(milliseconds: 200),
                        child: _buildSectionHeader(context, AppStrings.spendingByCategory),
                      ),
                      SizedBox(height: 16.h),
                      FadeSlideAnimation(
                        delay: Duration(milliseconds: 300),
                        child: _buildCategorySection(context, data),
                      ),
                      SizedBox(height: 24.h),

                      // Income vs Expense Trend
                      FadeSlideAnimation(
                        delay: Duration(milliseconds: 400),
                        child: _buildSectionHeader(context, AppStrings.incomeVsExpense),
                      ),
                      SizedBox(height: 16.h),
                      FadeSlideAnimation(
                        delay: Duration(milliseconds: 500),
                        child: _buildTrendSection(context, data),
                      ),
                      SizedBox(height: 24.h),

                      // Legend
                      FadeSlideAnimation(
                        delay: Duration(milliseconds: 600),
                        child: _buildLegend(),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDateRangeFilter(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 20.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(
            'Time Period:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Wrap(
              spacing: 8.w,
              children: [
                _buildFilterChip(context, AppStrings.last3Months, () {
                  final endDate = DateTime.now();
                  final startDate = DateTime(endDate.year, endDate.month - 3, endDate.day);
                  context.read<AnalyticsCubit>().loadAnalytics(
                    startDate: startDate,
                    endDate: endDate,
                  );
                }),
                _buildFilterChip(context, AppStrings.last6Months, () {
                  final endDate = DateTime.now();
                  final startDate = DateTime(endDate.year, endDate.month - 6, endDate.day);
                  context.read<AnalyticsCubit>().loadAnalytics(
                    startDate: startDate,
                    endDate: endDate,
                  );
                }),
                _buildFilterChip(context, AppStrings.thisYear, () {
                  final now = DateTime.now();
                  context.read<AnalyticsCubit>().loadAnalytics(
                    startDate: DateTime(now.year, 1, 1),
                    endDate: now,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha((255 * 0.1).round()),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyOverview(BuildContext context, data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.monthlyOverview,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                context,
                AppStrings.income,
                CurrencyHelper.format(data.totalIncome),
                AppColors.success,
                Icons.arrow_downward,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildOverviewCard(
                context,
                AppStrings.expense,
                CurrencyHelper.format(data.totalExpense),
                AppColors.error,
                Icons.arrow_upward,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                context,
                AppStrings.netSavings,
                CurrencyHelper.format(data.netSavings),
                AppColors.primary,
                Icons.savings,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildOverviewCard(
                context,
                AppStrings.topCategory,
                data.topSpendingCategory,
                AppColors.warning,
                Icons.star,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha((255 * 0.3).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: color),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SpendingPieChart(categoryBreakdown: data.categoryBreakdown),
          SizedBox(height: 16.h),
          ...data.categoryBreakdown.entries.map((entry) {
            return _buildCategoryItem(entry.key, entry.value, data.totalExpense);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, double amount, double total) {
    final percentage = (amount / total * 100).toStringAsFixed(1);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '${CurrencyHelper.format(amount)} ($percentage%)',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendSection(BuildContext context, data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TrendBarChart(monthlyTrends: data.monthlyTrends),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(AppStrings.income, AppColors.success),
        SizedBox(width: 24.w),
        _buildLegendItem(AppStrings.expense, AppColors.error),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
