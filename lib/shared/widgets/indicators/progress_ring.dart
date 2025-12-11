import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors.dart';
import '../../const/design_tokens.dart';

/// Circular progress ring indicator with percentage in center
class ProgressRing extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final bool showPercentage;
  final TextStyle? percentageStyle;
  final Widget? centerWidget;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 10,
    this.color,
    this.backgroundColor,
    this.showPercentage = true,
    this.percentageStyle,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ??
        (progress > 0.8
            ? AppColors.warning
            : (progress > 0.5 ? AppColors.primary : AppColors.success));

    return SizedBox(
      width: size.w,
      height: size.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            backgroundColor: backgroundColor ?? AppColors.grey.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation(Colors.transparent),
          ),

          // Progress circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress),
            duration: DesignTokens.durationSlow,
            curve: Curves.easeInOutCubic,
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation(effectiveColor),
                strokeCap: StrokeCap.round,
              );
            },
          ),

          // Center content
          if (centerWidget != null)
            centerWidget!
          else if (showPercentage)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress * 100),
              duration: DesignTokens.durationSlow,
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                return Text(
                  '${value.toInt()}%',
                  style: percentageStyle ??
                      TextStyle(
                        fontSize: (size * 0.24).sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                );
              },
            ),
        ],
      ),
    );
  }
}
