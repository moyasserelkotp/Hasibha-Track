import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../const/colors.dart';
import '../../utils/routes.dart';

class AiFloatingButton extends StatelessWidget {
  const AiFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary, 
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(AppRoutes.aiChat);
          },
          borderRadius: BorderRadius.circular(28.r),
          child: Center(
            child: Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
        ),
      ),
    );
  }
}
