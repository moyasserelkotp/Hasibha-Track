
import '../../dtos/login_request_dto.dart';
import '../../dtos/register_request_dto.dart';
import '../../models/auth_result_model.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';

/// Remote data source interface for authentication
abstract class AuthRemoteDataSource {
  // ========== Authentication ==========
  
  /// Login with credentials (email, phone, or identifier)
  Future<AuthResultModel> login(LoginRequestDto dto);

  /// Register new user (email-based)
  Future<AuthResultModel> register(RegisterRequestDto dto);

  /// Sign in with Google ID token
  Future<AuthResultModel> signInWithGoogle(String idToken);

  /// Check authentication status
  Future<UserModel> checkAuthStatus();

  // ========== Password Management ==========

  /// Send password reset email (forgot password)
  Future<String> sendPasswordResetEmail(String email);

  /// Reset password with code from email
  Future<String> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  // ========== Token Management ==========

  /// Refresh access token
  Future<AuthTokensModel> refreshToken(String refreshToken);

  /// Logout (revoke refresh token)
  Future<void> logout(String refreshToken);
}
