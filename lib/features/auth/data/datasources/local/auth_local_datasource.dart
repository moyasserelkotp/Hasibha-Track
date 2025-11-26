import '../../models/auth_tokens_model.dart';

/// Local data source interface for authentication
abstract class AuthLocalDataSource {
  /// Save authentication tokens
  Future<void> saveTokens(AuthTokensModel tokens);

  /// Get saved tokens
  Future<AuthTokensModel?> getTokens();

  /// Get access token only
  Future<String?> getAccessToken();

  /// Get refresh token only
  Future<String?> getRefreshToken();

  /// Check if valid session exists
  Future<bool> hasValidSession();

  /// Clear all authentication data
  Future<void> clearTokens();
}
