import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/auth_result.dart';
import '../entities/auth_tokens.dart';

/// Authentication repository interface
/// Defines all authentication-related operations
abstract class AuthRepository {
  // ========== Authentication ==========

  /// Login with username and password
  Future<Either<Failure, AuthResult>> login({
    required String username,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, String>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? mobile,
  });

  /// Verify OTP after registration
  Future<Either<Failure, AuthResult>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Resend OTP to email
  Future<Either<Failure, String>> resendOtp(String email);

  /// Sign in with Google
  Future<Either<Failure, AuthResult>> signInWithGoogle();

  // ========== Password Management ==========

  /// Send password reset email
  Future<Either<Failure, String>> sendPasswordResetEmail(String email);

  /// Verify OTP for password reset
  Future<Either<Failure, String>> verifyPasswordResetOtp({
    required String resetToken,
    required String otp,
  });

  /// Complete password reset
  Future<Either<Failure, String>> resetPassword({
    required String resetToken,
    required String newPassword,
  });

  /// Change password for authenticated user
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // ========== Token Management ==========

  /// Refresh access token using refresh token
  Future<Either<Failure, AuthTokens>> refreshAccessToken(String refreshToken);

  /// Check if user has valid authentication
  Future<Either<Failure, bool>> checkAuthStatus();

  /// Logout user and clear tokens
  Future<Either<Failure, void>> logout();
}
