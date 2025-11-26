import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../domain/entities/budget.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/widgets/animations/fade_in_animation.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = budget.percentageSpent / 100;
    final isOverBudget = budget.isExceeded;
    final isWarning = budget.isApproachingLimit;

    Color progressColor;
    if (isOverBudget) {
      progressColor = Colors.red;
    } else if (isWarning) {
      progressColor = Colors.orange;
    } else {
      progressColor = AppColors.primary;
    }

    return SlideInAnimation(
      delay: Duration(milliseconds: 50 * index),
      child: Card(
        margin: EdgeInsets.only(bottom: 16.h),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Circular Progress
                CircularPercentIndicator(
                  radius: 35.r,
                  lineWidth: 6.w,
                  percent: percentage > 1.0 ? 1.0 : percentage,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${budget.percentageSpent.toInt()}%',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: progressColor,
                        ),
                      ),
                    ],
                  ),
                  progressColor: progressColor,
                  backgroundColor: progressColor.withValues(alpha: 0.2),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                SizedBox(width: 16.w),

                // Budget Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPeriodLabel(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$${budget.spent.toStringAsFixed(2)} of \$${budget.limit.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$${budget.remaining.toStringAsFixed(2)} remaining',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isOverBudget ? Colors.red : AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isOverBudget || isWarning) ...[
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: isOverBudget
                                ? Colors.red.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            isOverBudget ? 'Over Budget!' : 'Approaching Limit',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: isOverBudget ? Colors.red : Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPeriodLabel() {
    switch (budget.period) {
      case BudgetPeriod.daily:
        return 'Daily Budget';
      case BudgetPeriod.weekly:
        return 'Weekly Budget';
      case BudgetPeriod.monthly:
        return 'Monthly Budget';
      case BudgetPeriod.yearly:
        return 'Yearly Budget';
      case BudgetPeriod.custom:
        return 'Custom Budget';
    }
  }
}
