import 'package:dio/dio.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../../../../shared/core/api/api_constants.dart';

import '../../dtos/login_request_dto.dart';
import '../../dtos/register_request_dto.dart';
import '../../models/auth_result_model.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';
import '../../models/user_model.dart';
import '../dtos/sms_send_request_dto.dart';
import '../dtos/sms_verify_request_dto.dart';
import '../dtos/change_password_request_dto.dart';
import '../models/remote/sms_verify_response_model.dart';
import '../models/two_factor_setup_response_model.dart';
import '../models/two_factor_status_model.dart';
import '../models/device_model.dart';
import 'auth_remote_datasource.dart';

/// Implementation of remote data source using Dio
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  // ========== Authentication ==========

  @override
  Future<AuthResultModel> login(LoginRequestDto dto) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: dto.toJson(),
      );

      // Check if response contains success field
      if (response.data['success'] == false) {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }

      return AuthResultModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> register(RegisterRequestDto dto) async {
    try {
      final response = await dio.post(
        ApiConstants.signup,
        data: dto.toJson(),
      );

      // Check if response contains success field
      if (response.data['success'] == false) {
        throw ServerException(
          message: response.data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }

      return AuthResultModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> signInWithGoogle(String idToken) async {
    try {
      final response = await dio.post(
        ApiConstants.googleSignIn,
        data: {'idToken': idToken},
      );

      if (response.data['success'] == false) {
        throw ServerException(
          message: response.data['message'] ?? 'Google sign-in failed',
          statusCode: response.statusCode,
        );
      }

      return AuthResultModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> checkAuthStatus() async {
    try {
      final response = await dio.get(ApiConstants.authMe);

      if (response.data['success'] == false) {
        throw ServerException(
          message: response.data['message'] ?? 'Authentication check failed',
          statusCode: response.statusCode,
        );
      }

      return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ========== Password Management ==========

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      return response.data['message'] ??
          'If the email exists, a reset code has been sent.';
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.resetPassword,
        data: {
          'email': email,
          'code': code,
          'newPassword': newPassword,
        },
      );

      if (response.data['success'] == false) {
        throw ServerException(
          message: response.data['message'] ?? 'Password reset failed',
          statusCode: response.statusCode,
        );
      }

      return response.data['message'] ?? 'Password reset successful.';
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ========== Token Management ==========

  @override
  Future<AuthTokensModel> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.data['success'] == false) {
        throw ServerException(
          message: response.data['message'] ?? 'Token refresh failed',
          statusCode: response.statusCode,
        );
      }

      return AuthTokensModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await dio.post(
        ApiConstants.logout,
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ========== SMS Verification ==========

  @override
  Future<bool> sendSmsCode(SmsSendRequestDto dto) async {
    try {
      final response = await dio.post(
        ApiConstants.smsSend,
        data: dto.toJson(),
      );

      if (response.data['success'] == false) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to send SMS code',
          statusCode: response.statusCode,
        );
      }

      return response.data['success'] ?? false;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SmsVerifyResponseModel> verifySmsCode(SmsVerifyRequestDto dto) async {
    try {
      final response = await dio.post(
        ApiConstants.smsVerify,
        data: dto.toJson(),
      );

      if (response.data['success'] == false) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to verify SMS code',
          statusCode: response.statusCode,
        );
      }

      return SmsVerifyResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ========== Security & 2FA ==========

  @override
  Future<void> changePassword(ChangePasswordRequestDto dto) async {
    try {
      await dio.post(
        ApiConstants.changePassword,
        data: dto.toJson(),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TwoFactorSetupResponseModel> setup2fa() async {
    try {
      final response = await dio.post(ApiConstants.setup2fa);
      return TwoFactorSetupResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<String>> verify2fa(String token) async {
    try {
      final response = await dio.post(
        ApiConstants.verify2fa,
        data: {'token': token},
      );
      return List<String>.from(response.data['backupCodes'] as List);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TwoFactorStatusModel> get2faStatus() async {
    try {
      final response = await dio.get(ApiConstants.status2fa);
      return TwoFactorStatusModel.fromJson(response.data);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> disable2fa({String? token, required String password}) async {
    try {
      await dio.post(
        ApiConstants.disable2fa,
        data: {
          if (token != null) 'token': token,
          'password': password,
        },
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ========== Device Management ==========

  @override
  Future<List<DeviceModel>> getDevices() async {
    try {
      final response = await dio.get(ApiConstants.devices);
      final List devicesJson = response.data['devices'] as List;
      return devicesJson
          .map((json) => DeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<DeviceModel> trustDevice(String deviceId) async {
    try {
      final response = await dio.put(
        ApiConstants.deviceTrust.replaceFirst('{deviceId}', deviceId),
      );
      return DeviceModel.fromJson(response.data['device'] as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> removeDevice(String deviceId) async {
    try {
      await dio.delete(
        ApiConstants.deviceRemove.replaceFirst('{deviceId}', deviceId),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ========== Helper Methods ==========

  /// Handles DioException by throwing appropriate exception type
  Never _handleDioException(DioException e) {
    // Check if it's a network connectivity issue
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw NetworkException(
        'Connection timeout. Please check your internet connection.',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      throw NetworkException(
        'No internet connection. Please check your network and try again.',
      );
    }

    // It's a server error - extract message from response
    if (e.response != null) {
      final data = e.response!.data;
      String errorMessage = 'An error occurred';

      if (data is Map<String, dynamic>) {
        // Try different error message keys
        errorMessage = data['message'] ??
            data['error'] ??
            data['detail'] ??
            data['non_field_errors']?.first ??
            'An error occurred';
      } else {
        errorMessage = data.toString();
      }

      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    }

    // Unknown error
    throw ServerException(
      message: e.message ?? 'An unexpected error occurred',
    );
  }
}
