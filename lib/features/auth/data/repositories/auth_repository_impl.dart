import 'package:dartz/dartz.dart';
import '../../../../shared/core/error/exceptions.dart';
import '../../../../shared/core/failure.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/two_factor_setup_response.dart';
import '../../domain/entities/two_factor_status.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../dtos/login_request_dto.dart';
import '../dtos/register_request_dto.dart';
import '../dtos/sms_send_request_dto.dart';
import '../dtos/sms_verify_request_dto.dart';
import '../dtos/change_password_request_dto.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';
import '../models/two_factor_setup_response_model.dart';
import '../models/two_factor_status_model.dart';
import '../models/device_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // ========== Authentication ==========

  @override
  Future<Either<Failure, AuthResult>> login({
    String? email,
    String? phone,
    String? identifier,
    required String password,
  }) async {
    try {
      final LoginRequestDto dto;
      
      if (email != null) {
        dto = LoginRequestDto.email(email: email, password: password);
      } else if (phone != null) {
        dto = LoginRequestDto.phone(phone: phone, password: password);
      } else if (identifier != null) {
        dto = LoginRequestDto.identifier(identifier: identifier, password: password);
      } else {
        return Left(ValidationFailure(
          message: 'Email, phone, or identifier is required for login',
          fieldErrors: const {'identifier': 'Email, phone, or identifier is required'},
        ));
      }
      
      final resultModel = await remoteDataSource.login(dto);
      
      // Save tokens locally
      await localDataSource.saveTokens(
        AuthTokensModel(
          accessToken: resultModel.tokens.accessToken,
          refreshToken: resultModel.tokens.refreshToken,
        ),
      );

      // Save user data locally
      if (resultModel.user is UserModel) {
        await localDataSource.saveUser(resultModel.user as UserModel);
      }
      
      // Convert model to entity
      return Right(resultModel.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
    String? phoneVerificationToken,
  }) async {
    try {
      final dto = RegisterRequestDto(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phone: phone,
        phoneVerificationToken: phoneVerificationToken,
      );
      
      final resultModel = await remoteDataSource.register(dto);
      
      // Save tokens locally
      await localDataSource.saveTokens(
        AuthTokensModel(
          accessToken: resultModel.tokens.accessToken,
          refreshToken: resultModel.tokens.refreshToken,
        ),
      );

      // Save user data locally
      if (resultModel.user is UserModel) {
        await localDataSource.saveUser(resultModel.user as UserModel);
      }
      
      // Convert model to entity
      return Right(resultModel.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> signInWithGoogle(String idToken) async {
    try {
      final resultModel = await remoteDataSource.signInWithGoogle(idToken);
      
      // Save tokens locally
      await localDataSource.saveTokens(
        AuthTokensModel(
          accessToken: resultModel.tokens.accessToken,
          refreshToken: resultModel.tokens.refreshToken,
        ),
      );

      // Save user data locally
      if (resultModel.user is UserModel) {
        await localDataSource.saveUser(resultModel.user as UserModel);
      }
      
      // Convert model to entity
      return Right(resultModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> checkAuthStatus() async {
    try {
      final userModel = await remoteDataSource.checkAuthStatus();
      
      // Update local user data
      await localDataSource.saveUser(userModel);
      
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      // If server returns 401, clear local auth
      if (e.statusCode == 401) {
        await localDataSource.clearTokens();
        await localDataSource.clearUser();
      }
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ========== Password Management ==========

  @override
  Future<Either<Failure, String>> sendPasswordResetEmail(String email) async {
    try {
      final message = await remoteDataSource.sendPasswordResetEmail(email);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final message = await remoteDataSource.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ========== Token Management ==========

  @override
  Future<Either<Failure, AuthTokens>> refreshAccessToken(
    String refreshToken,
  ) async {
    try {
      final tokensModel = await remoteDataSource.refreshToken(refreshToken);
      
      // Save new tokens locally
      await localDataSource.saveTokens(tokensModel);
      
      // Convert model to entity
      return Right(tokensModel.toEntity());
    } on ServerException catch (e) {
      // If refresh token is invalid/expired, clear local auth
      if (e.statusCode == 401) {
        await localDataSource.clearTokens();
        await localDataSource.clearUser();
      }
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getUser();
      return Right(userModel?.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get current user'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Get refresh token before clearing
      final tokens = await localDataSource.getTokens();
      
      // Call backend logout if we have a refresh token
      if (tokens != null && tokens.refreshToken.isNotEmpty) {
        try {
          await remoteDataSource.logout(tokens.refreshToken);
        } catch (e) {
          // Ignore backend errors during logout
        }
      }
      
      // Clear local data
      await localDataSource.clearTokens();
      await localDataSource.clearUser();
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to logout'));
    }
  }

  // ========== SMS Verification ==========

  @override
  Future<Either<Failure, bool>> sendSmsCode(String phone) async {
    try {
      final result = await remoteDataSource.sendSmsCode(
        SmsSendRequestDto(phone: phone),
      );
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifySmsCode({
    required String phone,
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.verifySmsCode(
        SmsVerifyRequestDto(phone: phone, code: code),
      );
      
      if (result.phoneVerificationToken == null) {
        return Left(ServerFailure(message: 'Verification token missing in response'));
      }
      
      return Right(result.phoneVerificationToken!);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ========== Security & 2FA ==========

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        ChangePasswordRequestDto(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorSetupResponse>> setup2fa() async {
    try {
      final model = await remoteDataSource.setup2fa();
      return Right(TwoFactorSetupResponse(
        message: model.message,
        qrCode: model.qrCode,
        secret: model.secret,
        backupCodes: model.backupCodes,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> verify2fa(String token) async {
    try {
      final backupCodes = await remoteDataSource.verify2fa(token);
      return Right(backupCodes);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TwoFactorStatus>> get2faStatus() async {
    try {
      final model = await remoteDataSource.get2faStatus();
      return Right(TwoFactorStatus(
        enabled: model.enabled,
        method: model.method,
        verifiedAt: model.verifiedAt,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disable2fa({
    String? token,
    required String password,
  }) async {
    try {
      await remoteDataSource.disable2fa(token: token, password: password);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ========== Device Management ==========

  @override
  Future<Either<Failure, List<Device>>> getDevices() async {
    try {
      final models = await remoteDataSource.getDevices();
      return Right(models.map((m) => _mapDeviceModelToEntity(m)).toList());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Device>> trustDevice(String deviceId) async {
    try {
      final model = await remoteDataSource.trustDevice(deviceId);
      return Right(_mapDeviceModelToEntity(model));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeDevice(String deviceId) async {
    try {
      await remoteDataSource.removeDevice(deviceId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Device _mapDeviceModelToEntity(DeviceModel model) {
    return Device(
      id: model.id,
      deviceId: model.deviceId,
      deviceName: model.deviceName,
      deviceType: model.deviceType,
      platform: model.platform,
      browser: model.browser,
      ipAddress: model.ipAddress,
      city: model.city,
      country: model.country,
      lastActive: model.lastActive,
      isTrusted: model.isTrusted,
      createdAt: model.createdAt,
    );
  }
}
