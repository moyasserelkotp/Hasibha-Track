import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors.dart';
import '../../const/design_tokens.dart';
import '../animations/animated_widgets.dart';

class EnhancedEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;
  final List<String>? tips;
  final bool showAnimation;

  const EnhancedEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionText,
    this.onAction,
    this.tips,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Icon
            if (showAnimation)
              PulsingIcon(
                icon: icon,
                size: 120,
                color: AppColors.primary.withValues(alpha: 0.6),
              )
            else
              Icon(
                icon,
                size: 120.sp,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            
            SizedBox(height: DesignTokens.space24),
            
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: DesignTokens.text2xl,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: DesignTokens.space12),
            
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: DesignTokens.textBase,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Tips
            if (tips != null && tips!.isNotEmpty) ...[
              SizedBox(height: DesignTokens.space24),
              Container(
                padding: EdgeInsets.all(DesignTokens.space16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: DesignTokens.borderRadiusMd,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Quick Tips',
                          style: TextStyle(
                            fontSize: DesignTokens.textBase,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: DesignTokens.space12),
                    ...tips!.map((tip) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 16.sp,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  tip,
                                  style: TextStyle(
                                    fontSize: DesignTokens.textSm,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
            
            // Action Button
            if (actionText != null && onAction != null) ...[
              SizedBox(height: DesignTokens.space32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add),
                  label: Text(actionText!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: DesignTokens.space16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: DesignTokens.borderRadiusLg,
                    ),
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
