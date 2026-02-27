import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/utils/routes.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/circular_progress_button.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController _pageController = PageController();

  final List<OnboardingPageData> _items = [
    OnboardingPageData(
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
      lottieAsset: 'assets/lotties/Track & Calculator.json',
      color: const Color(0xFF00A38E),
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
      lottieAsset: 'assets/lotties/Live chatbot.json',
      color: const Color(0xFF6C63FF),
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
      lottieAsset: 'assets/lotties/Money.json',
      color: const Color(0xFF00A38E),
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle4,
      description: AppStrings.onboardingDesc4,
      lottieAsset: 'assets/lotties/Finance guru.json',
      color: const Color(0xFF42A5F5),
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
          final progress = (cubit.currentPage + 1) / _items.length;

          return PopScope(
            canPop: false,
            child: Scaffold(
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    // Skip button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.w, top: 16.h),
                        child: TextButton(
                          onPressed: () => cubit.completeOnboarding(),
                          child: Text(
                            AppStrings.skip,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
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
                        itemBuilder: (context, index) {
                          return OnboardingPageWidget(
                            lottieAsset: _items[index].lottieAsset,
                            title: _items[index].title,
                            description: _items[index].description,
                            color: _items[index].color,
                          );
                        },
                      ),
                    ),

                    // Circular Progress Button
                    Padding(
                      padding: EdgeInsets.only(bottom: 60.h),
                      child: CircularProgressButton(
                        progress: progress,
                        color: _items[cubit.currentPage].color,
                        isLastPage: isLastPage,
                        onTap: () {
                          if (isLastPage) {
                            cubit.completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
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

class OnboardingPageData {
  final String title;
  final String description;
  final String lottieAsset;
  final Color color;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.color,
  });
}
