import 'package:flutter/material.dart';
import '../../../../../shared/const/colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;

  const OnboardingIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: currentPage == index
                ? AppColors.primary
                : AppColors.greyLight,
          ),
        ),
      ),
    );
  }
}
