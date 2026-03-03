import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/auth_result.dart';
import '../entities/auth_tokens.dart';
import '../entities/user.dart';
import '../entities/two_factor_setup_response.dart';
import '../entities/two_factor_status.dart';
import '../entities/device.dart';

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
    String? phoneVerificationToken,
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

  // ========== SMS Verification ==========

  /// Send SMS code for phone verification
  Future<Either<Failure, bool>> sendSmsCode(String phone);

  /// Verify SMS code and get phone verification token
  Future<Either<Failure, String>> verifySmsCode({
    required String phone,
    required String code,
  });

  // ========== Security & 2FA ==========

  /// Change user password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Initiate 2FA setup
  Future<Either<Failure, TwoFactorSetupResponse>> setup2fa();

  /// Verify and enable 2FA
  Future<Either<Failure, List<String>>> verify2fa(String token);

  /// Get 2FA status
  Future<Either<Failure, TwoFactorStatus>> get2faStatus();

  /// Disable 2FA
  Future<Either<Failure, void>> disable2fa({
    String? token,
    required String password,
  });

  // ========== Device Management ==========

  /// List trusted devices
  Future<Either<Failure, List<Device>>> getDevices();

  /// Trust a device
  Future<Either<Failure, Device>> trustDevice(String deviceId);

  /// Remove a device
  Future<Either<Failure, void>> removeDevice(String deviceId);
}
