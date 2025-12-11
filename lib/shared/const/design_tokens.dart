import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Design tokens for consistent styling across the app
/// Provides centralized spacing, radius, shadows, and animation values
class DesignTokens {
  DesignTokens._();

  // ============ SPACING ============
  static double get space2 => 2.w;
  static double get space4 => 4.w;
  static double get space8 => 8.w;
  static double get space12 => 12.w;
  static double get space16 => 16.w;
  static double get space20 => 20.w;
  static double get space24 => 24.w;
  static double get space32 => 32.w;
  static double get space40 => 40.w;
  static double get space48 => 48.w;

  // ============ BORDER RADIUS ============
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 20.r;
  static double get radius2xl => 24.r;
  static double get radiusFull => 999.r;

  static BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadius2xl => BorderRadius.circular(radius2xl);

  // ============ ELEVATION & SHADOWS ============
  
  /// Subtle shadow for cards at rest
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  /// Standard shadow for elevated cards
  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Pronounced shadow for floating elements
  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Strong shadow for modals and dialogs
  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.16),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  /// Premium colored shadow
  static List<BoxShadow> coloredShadow(Color color, {double opacity = 0.3}) => [
        BoxShadow(
          color: color.withValues(alpha: opacity),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  // ============ GRADIENTS ============
  
  /// Hero gradient - Primary teal gradient for cards and CTAs
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF00BFA5), Color(0xFF00ACC1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// AI Assistant gradient - Purple gradient for AI features
  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFFAB47BC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Savings gradient - Green to teal for savings features
  static const LinearGradient savingsGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF00BFA5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Quick Action gradients
  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient scanGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient sharedBudgetGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Primary gradient (context-aware fallback)
  static LinearGradient primaryGradient(BuildContext context) {
    return heroGradient;
  }

  /// Success gradient for positive actions
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00C853), Color(0xFF69F0AE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Error gradient for destructive actions
  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Info gradient
  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF448AFF), Color(0xFF82B1FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Shimmer gradient for loading states
  static LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Colors.grey.shade300,
      Colors.grey.shade100,
      Colors.grey.shade300,
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ ANIMATION DURATIONS ============
  static const Duration durationInstant = Duration(milliseconds: 100);
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationSlower = Duration(milliseconds: 600);

  // ============ ANIMATION CURVES ============
  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveDecelerate = Curves.easeOut;
  static const Curve curveAccelerate = Curves.easeIn;
  static const Curve curveSmooth = Curves.easeInOutCubic;
  static const Curve curveSpring = Curves.elasticOut;

  // ============ ICON SIZES ============
  static double get iconXs => 16.sp;
  static double get iconSm => 20.sp;
  static double get iconMd => 24.sp;
  static double get iconLg => 32.sp;
  static double get iconXl => 48.sp;

  // ============ TYPOGRAPHY SIZES ============
  static double get textXs => 11.sp;
  static double get textSm => 13.sp;
  static double get textBase => 15.sp;
  static double get textLg => 17.sp;
  static double get textXl => 19.sp;
  static double get text2xl => 23.sp;
  static double get text3xl => 27.sp;
  static double get text4xl => 32.sp;

  // ============ OPACITY VALUES ============
  static const double opacityDisabled = 0.4;
  static const double opacitySubtle = 0.6;
  static const double opacityMedium = 0.8;
  static const double opacityFull = 1.0;

  // ============ GLASSMORPHISM ============
  static BoxDecoration glassDecoration({
    Color? backgroundColor,
    double blur = 10,
    double opacity = 0.1,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: (backgroundColor ?? Colors.white).withValues(alpha: opacity),
      borderRadius: borderRadiusLg,
      boxShadow: shadows ?? shadowMd,
      // Note: BackdropFilter should be applied as a separate widget
    );
  }
  
  // ============ GRADIENT DECORATIONS ============
  
  /// Hero gradient decoration for cards
  static BoxDecoration heroGradientDecoration({
    List<BoxShadow>? shadows,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: heroGradient,
      borderRadius: borderRadius ?? borderRadiusXl,
      boxShadow: shadows ?? [
        BoxShadow(
          color: const Color(0xFF00BFA5).withValues(alpha: 0.3),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }
  
  /// AI gradient decoration
  static BoxDecoration aiGradientDecoration({
    List<BoxShadow>? shadows,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: aiGradient,
      borderRadius: borderRadius ?? borderRadiusLg,
      boxShadow: shadows ?? [
        BoxShadow(
          color: const Color(0xFF7C4DFF).withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
  
  /// Savings gradient decoration
  static BoxDecoration savingsGradientDecoration({
    List<BoxShadow>? shadows,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: savingsGradient,
      borderRadius: borderRadius ?? borderRadiusXl,
      boxShadow: shadows ?? [
        BoxShadow(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  // ============ CHART COLORS ============
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFF8B5CF6), // Purple
    Color(0xFF06B6D4), // Cyan
    Color(0xFFEF4444), // Red
    Color(0xFF3B82F6), // Blue
    Color(0xFF84CC16), // Lime
    Color(0xFFF97316), // Orange
  ];

  // ============ BREAKPOINTS (for responsive design) ============
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 900;
  static const double breakpointDesktop = 1200;
}
