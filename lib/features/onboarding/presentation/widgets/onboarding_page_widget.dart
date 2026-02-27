import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/widgets/animations/fade_in_up.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String lottieAsset;
  final String title;
  final String description;
  final Color color;

  const OnboardingPageWidget({
    super.key,
    required this.lottieAsset,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          
          // Lottie Animation
          Center(
            child: Lottie.asset(
              lottieAsset,
              height: 280.h,
              fit: BoxFit.contain,
            ),
          ),
          
          const Spacer(flex: 2),
          
          // Title with fade-in animation
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // Description with fade-in animation
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.textDisabled,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
