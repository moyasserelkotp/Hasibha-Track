import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/models/auth_tokens_model.dart';
import '../../domain/entities/auth_tokens.dart';

/// Service for centralized token management
class TokenService {
  final AuthLocalDataSource localDataSource;

  TokenService({required this.localDataSource});

  /// Save authentication tokens
  Future<void> saveTokens(AuthTokens tokens) async {
    // Convert entity to model for storage
    final tokensModel = AuthTokensModel(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    await localDataSource.saveTokens(tokensModel);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await localDataSource.getAccessToken();
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await localDataSource.getRefreshToken();
  }

  /// Get both tokens
  Future<AuthTokens?> getTokens() async {
    final tokensModel = await localDataSource.getTokens();
    return tokensModel?.toEntity();
  }

  /// Check if user has valid tokens
  Future<bool> hasValidTokens() async {
    return await localDataSource.hasValidSession();
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await localDataSource.clearTokens();
  }

  /// Check if access token is expired (basic check)
  /// Note: For proper JWT validation, use a JWT package
  bool isTokenExpired(String token) {
    try {
      // Basic check - you may want to use a JWT package for proper validation
      if (token.isEmpty) return true;
      return false;
    } catch (e) {
      return true;
    }
  }
}


