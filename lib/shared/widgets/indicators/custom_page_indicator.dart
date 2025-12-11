import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors.dart';

/// Custom page indicator for onboarding with elongated active dot
class CustomPageIndicator extends StatelessWidget {
  final int currentPage;
  final int itemCount;
  final Color? activeColor;
  final Color? inactiveColor;

  const CustomPageIndicator({
    super.key,
    required this.currentPage,
    required this.itemCount,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: isActive ? 32.w : 8.w,
          decoration: BoxDecoration(
            color: isActive
                ? (activeColor ?? AppColors.primary)
                : (inactiveColor ?? AppColors.grey),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}
