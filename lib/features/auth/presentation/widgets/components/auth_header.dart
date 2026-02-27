import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../shared/const/colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo
        Center(
          child: Image.asset(
            'assets/images/app_logo.jpg',
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 24.h),
        // App Name
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 30.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6.h),
        // Subtitle / screen label
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
