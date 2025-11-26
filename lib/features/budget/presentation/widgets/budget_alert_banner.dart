import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/budget.dart';
import '../../../../shared/const/colors.dart';

enum AlertType { exceeded, approaching }

class BudgetAlertBanner extends StatelessWidget {
  final List<Budget> budgets;
  final AlertType type;

  const BudgetAlertBanner({
    super.key,
    required this.budgets,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isExceeded = type == AlertType.exceeded;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isExceeded
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isExceeded ? Colors.red : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isExceeded ? Icons.error_outline : Icons.warning_amber_rounded,
            color: isExceeded ? Colors.red : Colors.orange,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExceeded ? 'Budget Exceeded!' : 'Budget Warning',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isExceeded ? Colors.red : Colors.orange,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  isExceeded
                      ? '${budgets.length} budget(s) have been exceeded'
                      : '${budgets.length} budget(s) approaching limit',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
