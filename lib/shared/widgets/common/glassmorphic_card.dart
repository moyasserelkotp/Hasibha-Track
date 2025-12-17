import 'dart:ui';
import 'package:flutter/material.dart';
import '../../const/design_tokens.dart';

/// A reusable glassmorphic card widget with backdrop blur effect
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final Border? border;
  final double? width;
  final double? height;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.15,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.shadows,
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? DesignTokens.borderRadiusLg,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: DesignTokens.advancedGlassDecoration(
              backgroundColor: backgroundColor,
              blur: blur,
              opacity: opacity,
              borderRadius: borderRadius,
              shadows: shadows,
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A glassmorphic container without backdrop filter (for better performance)
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double opacity;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final Border? border;
  final double? width;
  final double? height;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    required this.child,
    this.opacity = 0.15,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.shadows,
    this.border,
    this.width,
    this.height,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null 
            ? (backgroundColor ?? Colors.white).withValues(alpha: opacity)
            : null,
        gradient: gradient,
        borderRadius: borderRadius ?? DesignTokens.borderRadiusLg,
        border: border ?? Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: shadows ?? DesignTokens.shadowMd,
      ),
      child: child,
    );
  }
}
