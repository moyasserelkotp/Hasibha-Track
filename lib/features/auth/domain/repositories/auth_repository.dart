import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/auth_result.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';

/// Authentication repository interface
/// Defines all authentication-related operations
abstract class AuthRepository {
  // ========== Authentication ==========

  /// Login with email, phone, or identifier
  Future<Either<Failure, AuthResult>> login({
    String? email,
    String? phone,
    String? identifier,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, AuthResult>> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  });

  /// Sign in with Google ID token
  Future<Either<Failure, AuthResult>> signInWithGoogle(String idToken);

  /// Check authentication status
  Future<Either<Failure, User>> checkAuthStatus();

  // ========== Password Management ==========

  /// Send password reset email
  Future<Either<Failure, String>> sendPasswordResetEmail(String email);

  /// Reset password with code from email
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  // ========== Token Management ==========

  /// Refresh access token using refresh token
  Future<Either<Failure, AuthTokens>> refreshAccessToken(String refreshToken);

  /// Get current authenticated user from local storage
  Future<Either<Failure, User?>> getCurrentUser();

  /// Logout user and clear tokens
  Future<Either<Failure, void>> logout();
}
