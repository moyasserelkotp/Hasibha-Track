import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/utils/routes.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_page_widget.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController _pageController = PageController();

  final List<OnboardingPageData> _items = [
    OnboardingPageData(
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
      imagePath: 'assets/lotties/Track & Calculator.json',
      color: AppColors.primary,
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
      imagePath: 'assets/lotties/Live chatbot.json',
      color: AppColors.accentPurple,
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
      imagePath: 'assets/lotties/Money.json',
      color: AppColors.secondary,
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle4,
      description: AppStrings.onboardingDesc4,
      imagePath: 'assets/lotties/Finance guru.json',
      color: AppColors.accentBlue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => di.sl<OnboardingCubit>(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            context.go(AppRoutes.login);
          } else if (state is OnboardingError) {
            AppSnackBar.showError(context, message: 'Error: ${state.message}');
          }
        },
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          final isLastPage = cubit.currentPage == _items.length - 1;

          return PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // Skip button
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isLastPage ? 0.0 : 1.0,
                              child: TextButton(
                                onPressed: isLastPage ? null : () => cubit.completeOnboarding(),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.textSecondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                child: Text(
                                  AppStrings.skip,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // PageView
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _items.length,
                            onPageChanged: cubit.onPageChanged,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return OnboardingPageWidget(
                                pageIndex: index,
                                imagePath: _items[index].imagePath,
                                title: _items[index].title,
                                description: _items[index].description,
                                color: _items[index].color,
                              );
                            },
                          ),
                        ),

                        // Bottom section with dynamic progress button
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: _OnboardingNavButton(
                            isLastPage: isLastPage,
                            isLoading: state is OnboardingLoading,
                            currentPage: cubit.currentPage,
                            totalPages: _items.length,
                            activeColor: _items[cubit.currentPage].color,
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              if (isLastPage) {
                                cubit.completeOnboarding();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutQuart,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Navigation button with progress border
class _OnboardingNavButton extends StatefulWidget {
  final bool isLastPage;
  final bool isLoading;
  final int currentPage;
  final int totalPages;
  final VoidCallback onPressed;
  final Color activeColor;

  const _OnboardingNavButton({
    required this.isLastPage,
    required this.isLoading,
    required this.currentPage,
    required this.totalPages,
    required this.onPressed,
    required this.activeColor,
  });

  @override
  State<_OnboardingNavButton> createState() => _OnboardingNavButtonState();
}

class _OnboardingNavButtonState extends State<_OnboardingNavButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double progress = (widget.currentPage + 1) / widget.totalPages;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading) widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          width: 80.w,
          height: 80.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress Border
              SizedBox(
                width: 80.w,
                height: 80.w,
                child: CustomPaint(
                  painter: _ProgressBorderPainter(
                    progress: progress,
                    color: widget.activeColor,
                    backgroundColor: AppColors.grey.withValues(alpha: 0.3),
                  ),
                ),
              ),
              // Inner Button
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: widget.activeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.activeColor.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: widget.isLoading
                    ? Center(
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : Icon(
                        widget.isLastPage
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 30.sp,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressBorderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _ProgressBorderPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 4) / 2;

    final paintBg = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paintBg);

    final paintProgress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -1.5708; // -90 degrees (top)
    final sweepAngle = 6.28319 * progress;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paintProgress);
  }

  @override
  bool shouldRepaint(covariant _ProgressBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class OnboardingPageData {
  final String title;
  final String description;
  final String imagePath;
  final Color color;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
  });
}
