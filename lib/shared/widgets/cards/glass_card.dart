import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/design_tokens.dart';

/// Glass card with frosted glass effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double opacity;
  final double blur;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const GlassCard({
    super.key,
    required this.child,
    this.elevation = 0,
    this.borderRadius,
    this.backgroundColor,
    this.opacity = 0.1,
    this.blur = 10,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? DesignTokens.borderRadiusLg;

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? EdgeInsets.all(DesignTokens.space16),
          decoration: BoxDecoration(
            color: (backgroundColor ?? Colors.white).withValues(alpha: opacity),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: elevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1 * (elevation / 10)),
                      blurRadius: elevation * 2,
                      offset: Offset(0, elevation / 2),
                    ),
                  ]
                : null,
          ),
          child: onTap != null
              ? InkWell(
                  onTap: onTap,
                  borderRadius: effectiveBorderRadius,
                  child: child,
                )
              : child,
        ),
      ),
    );
  }
}
