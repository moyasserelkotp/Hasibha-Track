import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors.dart';
import '../../const/design_tokens.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color color;
  final Color backgroundColor;
  final double height;
  final String? label;
  final String? valueText;
  final bool showPercentage;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.color = AppColors.primary,
    this.backgroundColor = AppColors.greyLight,
    this.height = 8,
    this.label,
    this.valueText,
    this.showPercentage = true,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignTokens.durationNormal,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress.clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null || widget.valueText != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: DesignTokens.textSm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (widget.valueText != null || widget.showPercentage)
                  Text(
                    widget.valueText ??
                        '${(widget.progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: DesignTokens.textSm,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
              ],
            ),
          ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                // Background
                Container(
                  height: widget.height.h,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                ),
                // Foreground (animated)
                FractionallySizedBox(
                  widthFactor: _animation.value,
                  child: Container(
                    height: widget.height.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color,
                          widget.color.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(widget.height / 2),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
