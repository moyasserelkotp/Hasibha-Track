import '../../dtos/change_password_request_dto.dart';
import '../../dtos/login_request_dto.dart';
import '../../dtos/register_request_dto.dart';
import '../../dtos/verify_otp_request_dto.dart';
import '../../models/auth_result_model.dart';
import '../../models/auth_tokens_model.dart';

/// Remote data source interface for authentication
abstract class AuthRemoteDataSource {
  // ========== Authentication ==========
  
  /// Login with credentials
  Future<AuthResultModel> login(LoginRequestDto dto);

  /// Register new user
  Future<String> register(RegisterRequestDto dto);

  /// Verify OTP after registration
  Future<AuthResultModel> verifyOtp(VerifyOtpRequestDto dto);

  /// Resend OTP to email
  Future<String> resendOtp(String email);

  /// Sign in with Google
  Future<AuthResultModel> signInWithGoogle();

  // ========== Password Management ==========

  /// Send password reset email
  Future<String> sendPasswordResetEmail(String email);

  /// Verify OTP for password reset
  Future<String> verifyPasswordResetOtp({
    required String resetToken,
    required String otp,
  });

  /// Complete password reset
  Future<String> resetPassword({
    required String resetToken,
    required String password,
  });

  /// Change password for authenticated user
  Future<String> changePassword(ChangePasswordRequestDto dto);

  // ========== Token Management ==========

  /// Refresh access token
  Future<AuthTokensModel> refreshToken(String refreshToken);
}
