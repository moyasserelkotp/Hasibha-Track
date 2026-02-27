import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/utils/routes.dart';
import '../cubit/splash_cubit.dart';
import '../widgets/moving_points_background.dart';
import '../widgets/three_dots_loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _contentController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _contentController.forward();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashCubit>(
      create: (_) => di.sl<SplashCubit>()..checkAuthStatus(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          context.go(AppRoutes.onboarding);
          if (state is SplashNavigate) {
            // Wait for animation to finish or at least 2.5 seconds
            Future.delayed(const Duration(milliseconds: 2500), () {
              if (context.mounted) {
                // context.go(state.route);
              }
            });
          }
          if (state is SplashError) {
            context.go(AppRoutes.onboarding);
          }
        },
        child: PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: Stack(
              children: [
                // 1. Moving points background
                const MovingPointsBackground(),

                // 2. Main Content
                SafeArea(
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 3),
                          
                          // Logo Image
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Hero(
                              tag: 'app_logo',
                              child: Image.asset(
                                'assets/images/app_logo.jpg',
                                width: 120.w,
                                height: 120.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 40.h),
                          
                          // App Name
                          Text(
                            AppStrings.appName,
                            style: GoogleFonts.poppins(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary, // Darker teal from image
                              letterSpacing: 0.5,
                            ),
                          ),
                          
                          SizedBox(height: 12.h),
                          
                          // Tagline in pill background
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              AppStrings.appTagline,
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // Custom Loading Indicator
                          const ThreeDotsLoading(),

                          const Spacer(flex: 3),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
