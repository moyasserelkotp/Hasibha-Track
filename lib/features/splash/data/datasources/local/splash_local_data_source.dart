abstract class SplashLocalDataSource {
  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding();

  /// Check if user is authenticated (has valid token)
  Future<bool> isAuthenticated();
}
