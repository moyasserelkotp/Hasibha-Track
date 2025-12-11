import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/text_styles.dart';
import '../../../../shared/widgets/animations/fade_in_up.dart';

class OnboardingPageWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const OnboardingPageWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          
          // Animated Icon Container
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: EdgeInsets.all(40.w),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 120.sp,
                color: widget.color,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Title with fade-in animation
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.displaySmall(context).copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Description with fade-in animation
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Text(
              widget.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge(context).copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
