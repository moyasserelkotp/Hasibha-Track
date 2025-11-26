abstract class OnboardingLocalDataSource {
  /// Save onboarding completion status
  Future<bool> saveOnboardingCompletion();
  
  /// Check if onboarding has been completed
  Future<bool> hasCompletedOnboarding();
}
