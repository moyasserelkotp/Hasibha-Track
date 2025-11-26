import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/app_dimensions.dart';
import '../const/colors.dart';

class AppTheme {
  // Light Theme - Material 3 with Google Fonts
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Enable Material 3
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      // M3 addition for things like TextField fill
      surfaceContainerHighest: AppColors.greyLight,
    ),

    // Scaffold will now automatically use `colorScheme.background`

    // App Bar Theme
    appBarTheme: AppBarTheme(
      // Let's make the AppBar background color semantic
      backgroundColor: AppColors.surface,
      // Changed from AppColors.white
      elevation: AppDimensions.appBarElevation,
      centerTitle: false,
      // Icon and Title styles will now be inherited from the overall theme or can be specified
      // to use the semantic onSurface color for better consistency.
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      // CORRECTED: Copy an existing text style from the theme for efficiency and consistency.
      titleTextStyle: ThemeData
          .light()
          .textTheme
          .titleLarge
          ?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Typography using Google Fonts (Poppins)
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
    ),

    // Input Decoration Theme - Excellent. No changes needed.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(color: AppColors.error),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingMd,
      ),
      hintStyle: TextStyle(color: AppColors.textHint),
    ),

    // Elevated Button Theme - Excellent. No changes needed.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 2,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        minimumSize: Size(double.infinity, AppDimensions.buttonHeightMd),
      ),
    ),

    // Text Button Theme - Excellent. No changes needed.
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
      ),
    ),

    // Outlined Button Theme - Excellent. No changes needed.
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        minimumSize: Size(double.infinity, AppDimensions.buttonHeightMd),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: AppColors.textPrimary,
      size: AppDimensions.iconMd,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.divider,
      thickness: AppDimensions.dividerThickness,
      space: AppDimensions.spaceMd,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      elevation: AppDimensions.bottomNavElevation,
      type: BottomNavigationBarType.fixed,
    ),



    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: TextStyle(color: AppColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // Dark Theme - Material 3 with Google Fonts
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true, // Enable Material 3
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.black,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.black,
      error: AppColors.errorLight,
      onError: AppColors.black,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.white,
      surfaceContainerHighest: AppColors.greyDarker,
    ),

    // Typography using Google Fonts
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      elevation: AppDimensions.appBarElevation,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.white),
      // CORRECTED: Copy an existing text style from the theme.
      titleTextStyle: ThemeData
          .dark()
          .textTheme
          .titleLarge
          ?.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
    ),


    // Input Decoration Theme - Excellent.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(color: AppColors.errorLight),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingMd,
      ),
      hintStyle: TextStyle(color: AppColors.textHint),
    ),

    // Elevated Button Theme - Excellent.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.black,
        elevation: 2,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        minimumSize: Size(double.infinity, AppDimensions.buttonHeightMd),
      ),
    ),

    // SOLVED: Added missing button themes for dark mode for consistency.
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        // Use light primary for dark theme
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMd,
          vertical: AppDimensions.paddingSm,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: BorderSide(color: AppColors.primaryLight),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        minimumSize: Size(double.infinity, AppDimensions.buttonHeightMd),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: AppColors.white,
      size: AppDimensions.iconMd,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.dividerDark,
      thickness: AppDimensions.dividerThickness,
      space: AppDimensions.spaceMd,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.textSecondary,
      elevation: AppDimensions.bottomNavElevation,
      type: BottomNavigationBarType.fixed,
    ),



    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.white,
      contentTextStyle: TextStyle(color: AppColors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

