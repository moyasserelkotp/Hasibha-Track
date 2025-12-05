import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/utils/routes.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_page_widget.dart';
import '../widgets/onboarding_indicator.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController _pageController = PageController();

  final List<OnboardingPageData> _items = [
    OnboardingPageData(
      title: AppStrings.onboardingTitle1,
      description: AppStrings.onboardingDesc1,
      icon: Icons.receipt_long,
      color: AppColors.primary,
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle2,
      description: AppStrings.onboardingDesc2,
      icon: Icons.psychology_outlined,
      color: AppColors.primaryDark,
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle3,
      description: AppStrings.onboardingDesc3,
      icon: Icons.savings_outlined,
      color: AppColors.primaryLight,
    ),
    OnboardingPageData(
      title: AppStrings.onboardingTitle4,
      description: AppStrings.onboardingDesc4,
      icon: Icons.groups,
      color: AppColors.primary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (context) => di.sl<OnboardingCubit>(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingCompleted) {
            // Navigate to login and remove onboarding from stack
            context.go(AppRoutes.login);
          } else if (state is OnboardingError) {
            AppSnackBar.showError(context, message: 'Error: ${state.message}');
          }
        },
        builder: (context, state) {
          final cubit = context.read<OnboardingCubit>();
          final isLastPage = cubit.currentPage == _items.length - 1;

          return PopScope(
            canPop: false, // Prevent back navigation during onboarding
            child: Scaffold(
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    // Skip button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextButton(
                          onPressed: () => cubit.completeOnboarding(),
                          child: Text(
                            AppStrings.skip,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
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
                            icon: _items[index].icon,
                            title: _items[index].title,
                            description: _items[index].description,
                            color: _items[index].color,
                          );
                        },
                      ),
                    ),

                    // Bottom section with indicators and button
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          // Page indicators
                          OnboardingIndicator(
                            itemCount: _items.length,
                            currentPage: cubit.currentPage,
                          ),
                          const SizedBox(height: 30),

                          // Next/Get Started button
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              text: isLastPage ? AppStrings.getStarted : AppStrings.next,
                              isLoading: state is OnboardingLoading,
                              onPressed: () {
                                if (isLastPage) {
                                  cubit.completeOnboarding();
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
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
  final IconData icon;
  final Color color;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
