import 'package:dio/dio.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../../../../shared/core/api/api_constants.dart';
import '../../dtos/change_password_request_dto.dart';
import '../../dtos/login_request_dto.dart';
import '../../dtos/register_request_dto.dart';
import '../../dtos/verify_otp_request_dto.dart';
import '../../models/auth_result_model.dart';
import '../../models/auth_tokens_model.dart';
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
      return AuthResultModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> register(RegisterRequestDto dto) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: dto.toJson(),
      );
      return response.data['message'] ?? 'Registration successful. Please verify your email.';
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> verifyOtp(VerifyOtpRequestDto dto) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyOtp,
        data: dto.toJson(),
      );
      return AuthResultModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> resendOtp(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.resendOtp,
        data: {'email': email},
      );
      return response.data['message'] ?? 'OTP resent successfully';
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AuthResultModel> signInWithGoogle() async {
    try {
      // TODO: Implement Google Sign-In logic
      // This is a placeholder - implement with google_sign_in package
      throw ServerException(
        message: 'Google Sign-In not yet implemented',
        statusCode: 501,
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ========== Password Management ==========

  @override
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.resetPasswordEmail,
        data: {'email': email},
      );
      return response.data['message'] ?? 'Password reset email sent successfully';
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> verifyPasswordResetOtp({
    required String resetToken,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.resetPasswordVerifyOtp,
        data: {
          'token': resetToken,
          'otp': otp,
        },
      );
      return response.data['message'] ?? 'OTP verified successfully';
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> resetPassword({
    required String resetToken,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.resetPasswordFinish,
        data: {
          'token': resetToken,
          'password': password,
        },
      );
      return response.data['message'] ?? 'Password reset successfully';
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> changePassword(ChangePasswordRequestDto dto) async {
    try {
      final response = await dio.post(
        ApiConstants.changePassword,
        data: dto.toJson(),
      );
      return response.data['message'] ?? 'Password changed successfully';
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
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
        data: {'refresh': refreshToken},
      );
      return AuthTokensModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw ServerException(
        message: errorMessage,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // ========== Helper Methods ==========

  /// Extracts error message from DioException
  String _extractErrorMessage(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        // Try different error message keys
        return data['message'] ??
            data['error'] ??
            data['detail'] ??
            data['non_field_errors']?.first ??
            'An error occurred';
      }
      return data.toString();
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }
    return e.message ?? 'An unexpected error occurred';
  }
}
