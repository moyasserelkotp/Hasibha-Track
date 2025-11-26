import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../domain/entities/savings_goal.dart';
import '../../../../shared/const/colors.dart';

class SavingsGoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback onTap;
  final VoidCallback onAddFunds;

  const SavingsGoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    required this.onAddFunds,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 30.r,
              lineWidth: 6.w,
              percent: goal.progress,
              center: Icon(
                _getIconData(goal.icon),
                color: Color(goal.color),
                size: 24.sp,
              ),
              progressColor: Color(goal.color),
              backgroundColor: Color(goal.color).withValues(alpha: 0.1),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$${goal.currentAmount.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (goal.deadline != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Goal: ${_formatDate(goal.deadline!)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: goal.isDeadlineApproaching
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: onAddFunds,
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'car':
        return Icons.directions_car;
      case 'house':
        return Icons.home;
      case 'vacation':
        return Icons.flight;
      case 'emergency':
        return Icons.medical_services;
      case 'gadget':
        return Icons.devices;
      default:
        return Icons.savings;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
