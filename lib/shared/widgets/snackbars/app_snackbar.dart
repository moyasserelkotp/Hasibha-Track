import 'package:flutter/material.dart';

import '../../const/app_dimensions.dart';
import '../../const/app_strings.dart';
import '../../const/colors.dart';
import '../../style/app_styles.dart';

class AppSnackBar {
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.white, size: AppDimensions.iconMd),
            SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Text(
                message,
                style: AppStyles.styleNormal16(context).copyWith(color: AppColors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        margin: EdgeInsets.all(AppDimensions.marginMd),
      ),
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: AppColors.white, size: AppDimensions.iconMd),
            SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Text(
                message,
                style: AppStyles.styleNormal16(context).copyWith(color: AppColors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        margin: EdgeInsets.all(AppDimensions.marginMd),
        action: onRetry != null
            ? SnackBarAction(
                label: AppStrings.retry,
                textColor: AppColors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: AppColors.white, size: AppDimensions.iconMd),
            SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Text(
                message,
                style: AppStyles.styleNormal16(context).copyWith(color: AppColors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        margin: EdgeInsets.all(AppDimensions.marginMd),
      ),
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning, color: AppColors.white, size: AppDimensions.iconMd),
            SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Text(
                message,
                style: AppStyles.styleNormal16(context).copyWith(color: AppColors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.warning,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        margin: EdgeInsets.all(AppDimensions.marginMd),
      ),
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
