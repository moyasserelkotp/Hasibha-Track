import 'package:flutter/material.dart';

import '../../const/app_dimensions.dart';
import '../../const/colors.dart';
import '../../style/app_styles.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final Widget? action;
  final String? imagePath;

  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.action,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 200,
                height: 200,
              )
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                size: AppDimensions.iconXxl * 1.5,
                color: AppColors.greyDark,
              ),
            SizedBox(height: AppDimensions.spaceLg),
            Text(
              title,
              style: AppStyles.styleSemiBold21(context).copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
