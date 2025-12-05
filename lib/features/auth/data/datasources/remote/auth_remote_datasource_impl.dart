import 'package:dio/dio.dart';
import '../../../../../shared/core/error/exceptions.dart';
import '../../../../../shared/core/api/api_constants.dart';

import '../../dtos/login_request_dto.dart';
import '../../dtos/register_request_dto.dart';
import '../../models/auth_result_model.dart';
import '../../models/auth_tokens_model.dart';
import '../../models/user_model.dart';
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
