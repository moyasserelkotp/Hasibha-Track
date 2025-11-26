import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../../shared/const/colors.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_enums.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;
  final VoidCallback onTap;

  const DebtCard({
    super.key,
    required this.debt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isReceivable = debt.type.isReceivable;
    final primaryColor = isReceivable ? AppColors.success : AppColors.error;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(51),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      isReceivable
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          debt.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (debt.contactName != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            debt.contactName!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildStatusBadge(),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '\$${debt.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Remaining',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '\$${debt.remainingAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 8.h,
                percent: (debt.progressPercentage / 100).clamp(0.0, 1.0),
                backgroundColor: AppColors.grey,
                progressColor: primaryColor,
                barRadius: Radius.circular(4.r),
              ),
              SizedBox(height: 4.h),
              Text(
                '${debt.progressPercentage.toStringAsFixed(0)}% paid',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              if (debt.dueDate != null) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 12.sp, color: AppColors.textSecondary),
                    SizedBox(width: 4.w),
                    Text(
                      'Due: ${_formatDate(debt.dueDate!)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: debt.isOverdue ? AppColors.error : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String label;

    switch (debt.status) {
      case DebtStatus.PAID:
        badgeColor = AppColors.success;
        label = 'Paid';
        break;
      case DebtStatus.OVERDUE:
        badgeColor = AppColors.error;
        label = 'Overdue';
        break;
      case DebtStatus.PARTIALLY_PAID:
        badgeColor = AppColors.warning;
        label = 'Partial';
        break;
      default:
        badgeColor = AppColors.info;
        label = 'Active';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(51),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;

    if (diff < 0) {
      return '${diff.abs()} days ago';
    } else if (diff == 0) {
      return 'Today';
    } else if (diff == 1) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
