import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/const/colors.dart';

class DebtSummaryCard extends StatelessWidget {
  final double totalOwedToMe;
  final double totalOwedByMe;
  final double netBalance;

  const DebtSummaryCard({
    super.key,
    required this.totalOwedToMe,
    required this.totalOwedByMe,
    required this.netBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(76),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Net Balance',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withAlpha(204),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$${netBalance.abs().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (netBalance != 0)
            Text(
              netBalance > 0 ? 'In Your Favor' : 'You Owe',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withAlpha(229),
              ),
            ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  'Owed To Me',
                  totalOwedToMe,
                  AppColors.success,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildStat(
                  'Owed By Me',
                  totalOwedByMe,
                  AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, double amount, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withAlpha(204),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
