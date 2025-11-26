import 'package:flutter/material.dart';

import '../../const/app_dimensions.dart';
import '../../const/colors.dart';
import '../../style/app_styles.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: AppDimensions.iconXxl,
              color: AppColors.error,
            ),
            SizedBox(height: AppDimensions.spaceLg),
            Text(
              'Oops! Something went wrong',
              style: AppStyles.styleSemiBold25(context).copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spaceSm),
            Text(
              message,
              style: AppStyles.styleNormal16(context).copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppDimensions.spaceLg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLg,
                    vertical: AppDimensions.paddingMd,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class InlineError extends StatelessWidget {
  final String message;

  const InlineError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.errorLight.withOpacity(0.1),
        border: Border.all(color: AppColors.error),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: AppDimensions.iconMd),
          SizedBox(width: AppDimensions.spaceMd),
          Expanded(
            child: Text(
              message,
              style: AppStyles.styleNormal16(context).copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
