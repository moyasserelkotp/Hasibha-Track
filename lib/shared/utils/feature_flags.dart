import 'package:flutter/material.dart';
import '../const/app_strings.dart';
import '../widgets/snackbars/app_snackbar.dart';

enum Feature {
  addExpense,
  addIncome,
  analytics,
  notifications,
  profile,
}

class FeatureFlags {
  static bool isFeatureEnabled(Feature feature) {
    // Features enabled/disabled
    switch (feature) {
      case Feature.addExpense:
      case Feature.addIncome:
      case Feature.analytics:
        return true; // ENABLED
      case Feature.notifications:
      case Feature.profile:
        return false;
    }
  }

  static void handleFeatureNotAvailable(BuildContext context, Feature feature) {
    String featureName = '';
    switch (feature) {
      case Feature.addExpense:
        featureName = AppStrings.addExpense;
        break;
      case Feature.addIncome:
        featureName = AppStrings.addIncome;
        break;
      case Feature.analytics:
        featureName = AppStrings.analytics;
        break;
      case Feature.notifications:
        featureName = AppStrings.notifications;
        break;
      case Feature.profile:
        featureName = AppStrings.profile;
        break;
    }
    
    AppSnackBar.showInfo(
      context, 
      message: '$featureName - ${AppStrings.comingSoon}'
    );
  }
}
