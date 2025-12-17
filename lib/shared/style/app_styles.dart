import 'package:flutter/material.dart';
import '../const/text_styles.dart';

/// Legacy AppStyles class for backwards compatibility
/// Wraps AppTextStyles to provide the old interface
class AppStyles {
  // Legacy method names that map to AppTextStyles
  
  static TextStyle styleNormal16(BuildContext context) =>
      AppTextStyles.bodyLarge(context);

  static TextStyle styleNormal14(BuildContext context) =>
      AppTextStyles.bodyMedium(context);

  static TextStyle styleNormal13(BuildContext context) =>
      AppTextStyles.bodyMedium(context).copyWith(fontSize: 13);

  static TextStyle styleNormal12(BuildContext context) =>
      AppTextStyles.bodySmall(context);

  static TextStyle styleBold18(BuildContext context) =>
      AppTextStyles.titleLarge(context);

  static TextStyle styleBold16(BuildContext context) =>
      AppTextStyles.titleMedium(context);

  static TextStyle styleBold14(BuildContext context) =>
      AppTextStyles.titleSmall(context);

  static TextStyle styleSemiBold25(BuildContext context) =>
      AppTextStyles.headlineSmall(context).copyWith(fontSize: 25);

  static TextStyle styleSemiBold21(BuildContext context) =>
      AppTextStyles.titleLarge(context).copyWith(fontSize: 21, fontWeight: FontWeight.w600);

  static TextStyle styleHeading24(BuildContext context) =>
      AppTextStyles.headlineSmall(context);

  static TextStyle styleHeading20(BuildContext context) =>
      AppTextStyles.titleLarge(context).copyWith(fontSize: 20);

  static TextStyle styleCaption(BuildContext context) =>
      AppTextStyles.caption(context);

  static TextStyle styleButton(BuildContext context) =>
      AppTextStyles.button(context);

  static TextStyle styleSubtitle(BuildContext context) =>
      AppTextStyles.cardSubtitle(context);
}
