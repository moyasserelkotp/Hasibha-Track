import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hasibha/shared/style/text_scale.dart';

abstract class AppStyles {
  static TextStyle styleSemiBold21(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 21,
        fontWeight: FontWeight.w600,
      );

  static TextStyle styleSemiBold25(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 25,
        fontWeight: FontWeight.bold,
      );

  static TextStyle styleBold30(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 30,
        fontWeight: FontWeight.bold,
      );

  static TextStyle styleNormal16(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 16,
        fontWeight: FontWeight.w500,
      );

  static TextStyle styleBold16(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 15,
        fontWeight: FontWeight.bold,
      );

  static TextStyle styleBold18(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle styleBold12(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 12,
        fontWeight: FontWeight.w700,
      );

  static TextStyle styleBold28(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle styleNormal13(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 13,
        fontWeight: FontWeight.w500,
      );

  static TextStyle styleNormal17(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 17,
        fontWeight: FontWeight.w500,
      );

  static TextStyle styleSmall15(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 15,
        fontWeight: FontWeight.w300,
      );

  static TextStyle styleNormal11(BuildContext context) => GoogleFonts.poppins(
        fontSize: AppTextScales.textScaleFactor(context) * 11,
        fontWeight: FontWeight.w500,
      );
}
