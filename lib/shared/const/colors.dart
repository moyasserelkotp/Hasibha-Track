import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Teal/Mint Theme
  static const Color primary = Color(0xFF00BFA5); // Teal 400
  static const Color primaryLight = Color(0xFF64FFDA); // Teal 200
  static const Color primaryDark = Color(0xFF00897B); // Teal 600
  
  // Secondary Colors - Kept for compatibility
  static const Color secondary = Color(0xFF00ACC1); // Cyan 600
  static const Color secondaryLight = Color(0xFF4DD0E1); // Cyan 300
  static const Color secondaryDark = Color(0xFF00838F); // Cyan 800

  // Accent Colors - Purple (AI/Smart Features)
  static const Color accentPurple = Color(0xFF7C4DFF); // Deep Purple A200
  static const Color accentPurpleLight = Color(0xFFB47CFF);
  static const Color accentPurpleDark = Color(0xFF651FFF);
  
  // Accent Colors - Blue (Trust/Security)
  static const Color accentBlue = Color(0xFF2196F3); // Blue 500
  static const Color accentBlueLight = Color(0xFF64B5F6); // Blue 300
  static const Color accentBlueDark = Color(0xFF1976D2); // Blue 700
  
  // Legacy accent (for backward compatibility)
  static const Color accent = Color(0xFF7C4DFF);
  static const Color accentLight = Color(0xFFB47CFF);
  
  // Semantic Colors
  static const Color success = Color(0xFF00C853); // Green A700
  static const Color successLight = Color(0xFF69F0AE); // Green A200
  static const Color error = Color(0xFFFF5252); // Red A200
  static const Color errorLight = Color(0xFFFF8A80); // Red A100
  static const Color warning = Color(0xFFFFC107); // Amber 500
  static const Color warningLight = Color(0xFFFFD54F); // Amber 300
  static const Color info = Color(0xFF448AFF); // Blue A200
  static const Color infoLight = Color(0xFF82B1FF); // Blue A100
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color greyLight = Color(0xFFFAFAFA);
  static const Color greyDark = Color(0xFF757575);
  static const Color greyDarker = Color(0xFF424242);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Expense/Income Colors
  static const Color expense = Color(0xFFFF5252); // Softer red
  static const Color income = Color(0xFF00C853); // Brighter green
  
  // Gradient Colors - Hero (Primary Usage)
  static const List<Color> primaryGradient = [
    Color(0xFF00BFA5), // Teal
    Color(0xFF00ACC1), // Cyan
  ];

  // AI Assistant Gradient
  static const List<Color> aiGradient = [
    Color(0xFF7C4DFF), // Purple
    Color(0xFFAB47BC), // Purple 400
  ];
  
  // Savings Gradient
  static const List<Color> savingsGradient = [
    Color(0xFF4CAF50), // Green 500
    Color(0xFF00BFA5), // Teal
  ];
  
  // Secondary Gradient (kept for compatibility)
  static const List<Color> secondaryGradient = [
    Color(0xFF00ACC1),
    Color(0xFF4DD0E1),
  ];
  
  // Success Gradient
  static const List<Color> successGradient = [
    Color(0xFF00C853),
    Color(0xFF69F0AE),
  ];
  
  // Error Gradient
  static const List<Color> errorGradient = [
    Color(0xFFFF5252),
    Color(0xFFFF8A80),
  ];
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);
  
  // Divider Colors
  static const Color divider = Color(0xFFBDBDBD);
  static const Color dividerDark = Color(0xFF424242);
  
  // Shadow Colors
  static const Color shadow = Color(0x1F000000);
  static const Color shadowDark = Color(0x3F000000);
  // Social Colors
  static const Color googleRed = Color(0xFFDB4437);
  static const Color facebookBlue = Color(0xFF4267B2);
  static const Color tiktokBlack = Color(0xFF000000);
}

