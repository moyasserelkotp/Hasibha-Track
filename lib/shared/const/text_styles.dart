import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static TextStyle get _baseStyle => GoogleFonts.poppins();

  // Display Styles (Extra Large)
  static TextStyle displayLarge(BuildContext context) => _baseStyle.copyWith(
        fontSize: 57.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.displayLarge?.color ?? AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle displayMedium(BuildContext context) => _baseStyle.copyWith(
        fontSize: 45.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.displayMedium?.color ?? AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle displaySmall(BuildContext context) => _baseStyle.copyWith(
        fontSize: 36.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.displaySmall?.color ?? AppColors.textPrimary,
        height: 1.2,
      );

  // Headline Styles
  static TextStyle headlineLarge(BuildContext context) => _baseStyle.copyWith(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.headlineLarge?.color ?? AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle headlineMedium(BuildContext context) => _baseStyle.copyWith(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.headlineMedium?.color ?? AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle headlineSmall(BuildContext context) => _baseStyle.copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.headlineSmall?.color ?? AppColors.textPrimary,
        height: 1.3,
      );

  // Title Styles
  static TextStyle titleLarge(BuildContext context) => _baseStyle.copyWith(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textPrimary,
        letterSpacing: 0,
      );

  static TextStyle titleMedium(BuildContext context) => _baseStyle.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.textPrimary,
        letterSpacing: 0.15,
      );

  static TextStyle titleSmall(BuildContext context) => _baseStyle.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.titleSmall?.color ?? AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  // Body Styles
  static TextStyle bodyLarge(BuildContext context) => _baseStyle.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
        height: 1.5,
        letterSpacing: 0.5,
      );

  static TextStyle bodyMedium(BuildContext context) => _baseStyle.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textPrimary,
        height: 1.5,
        letterSpacing: 0.25,
      );

  static TextStyle bodySmall(BuildContext context) => _baseStyle.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary,
        height: 1.4,
        letterSpacing: 0.4,
      );

  // Label Styles
  static TextStyle labelLarge(BuildContext context) => _baseStyle.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.labelLarge?.color ?? AppColors.textPrimary,
        letterSpacing: 0.1,
      );

  static TextStyle labelMedium(BuildContext context) => _baseStyle.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.labelMedium?.color ?? AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  static TextStyle labelSmall(BuildContext context) => _baseStyle.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.labelSmall?.color ?? AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  // Custom App Styles
  static TextStyle currency(BuildContext context) => _baseStyle.copyWith(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: -0.5,
      );

  static TextStyle currencyLarge(BuildContext context) => _baseStyle.copyWith(
        fontSize: 42.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: -1,
      );

  static TextStyle amount(BuildContext context) => _baseStyle.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle amountPositive(BuildContext context) => amount(context).copyWith(
        color: AppColors.success,
      );

  static TextStyle amountNegative(BuildContext context) => amount(context).copyWith(
        color: AppColors.error,
      );

  static TextStyle button(BuildContext context) => _baseStyle.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.5,
      );

  static TextStyle buttonSmall(BuildContext context) => _baseStyle.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.5,
      );

  static TextStyle cardTitle(BuildContext context) => _baseStyle.copyWith(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle cardSubtitle(BuildContext context) => _baseStyle.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  static TextStyle caption(BuildContext context) => _baseStyle.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        letterSpacing: 0.4,
      );

  static TextStyle overline(BuildContext context) => _baseStyle.copyWith(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      ).copyWith(
        textBaseline: TextBaseline.alphabetic,
      );

  // Status Styles
  static TextStyle success(BuildContext context) => bodyMedium(context).copyWith(
        color: AppColors.success,
        fontWeight: FontWeight.w600,
      );

  static TextStyle error(BuildContext context) => bodyMedium(context).copyWith(
        color: AppColors.error,
        fontWeight: FontWeight.w600,
      );

  static TextStyle warning(BuildContext context) => bodyMedium(context).copyWith(
        color: AppColors.warning,
        fontWeight: FontWeight.w600,
      );

  static TextStyle info(BuildContext context) => bodyMedium(context).copyWith(
        color: AppColors.info,
        fontWeight: FontWeight.w600,
      );

  // Bottom Navigation
  static TextStyle bottomNavActive(BuildContext context) => _baseStyle.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  static TextStyle bottomNavInactive(BuildContext context) => _baseStyle.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );

  // Tab Styles
  static TextStyle tabActive(BuildContext context) => _baseStyle.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  static TextStyle tabInactive(BuildContext context) => _baseStyle.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      );
}
