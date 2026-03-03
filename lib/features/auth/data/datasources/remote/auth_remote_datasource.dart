
import '../../dtos/login_request_dto.dart';
import '../../dtos/register_request_dto.dart';
import '../../models/auth_result_model.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';
import '../dtos/sms_send_request_dto.dart';
import '../dtos/sms_verify_request_dto.dart';
import '../models/remote/sms_verify_response_model.dart';

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

  // ========== SMS Verification ==========
  
  /// Send SMS code for phone verification
  Future<bool> sendSmsCode(SmsSendRequestDto dto);

  /// Verify SMS code and get phone verification token
  Future<SmsVerifyResponseModel> verifySmsCode(SmsVerifyRequestDto dto);

  // ========== Security & 2FA ==========

  /// Change user password
  Future<void> changePassword(ChangePasswordRequestDto dto);

  /// Initiate 2FA setup
  Future<TwoFactorSetupResponseModel> setup2fa();

  /// Verify and enable 2FA
  Future<List<String>> verify2fa(String token);

  /// Get 2FA status
  Future<TwoFactorStatusModel> get2faStatus();

  /// Disable 2FA
  Future<void> disable2fa({String? token, required String password});

  // ========== Device Management ==========

  /// List trusted devices
  Future<List<DeviceModel>> getDevices();

  /// Trust a device
  Future<DeviceModel> trustDevice(String deviceId);

  /// Remove a device
  Future<void> removeDevice(String deviceId);
}
