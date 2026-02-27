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
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  
                  // Lottie Animation with Blob Background
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Decorative Blob
                        Container(
                          width: 260.w,
                          height: 190.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC0FFC0).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.all(Radius.elliptical(150.w, 100.h)),
                          ),
                        ),
                        Lottie.asset(
                          lottieAsset,
                          height: 260.h,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(flex: 1),
                  
                  // Title
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Description
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: const Color(0xFF888888),
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  
                  const Spacer(flex: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
