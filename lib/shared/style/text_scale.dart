import 'dart:math';
import 'package:flutter/material.dart';

class AppTextScales {
  static double textScaleFactor(BuildContext context,[double maxTextScaleFactor = .8]) {
    final width = MediaQuery.of(context).size.width;
    const double referenceWidth = 1400;
    double val = (width / referenceWidth) * maxTextScaleFactor;

    if (isMobile(context)) {
      return max(1.0, min(val, maxTextScaleFactor));
    } else if (isTablet(context)) {
      return max(1.3, min(val, maxTextScaleFactor));
    } else {
      return max(1, min(val, maxTextScaleFactor));
    }
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 900;
  }
}
