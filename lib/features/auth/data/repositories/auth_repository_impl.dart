import 'package:dartz/dartz.dart';
import '../../../../shared/core/error/exceptions.dart';
import '../../../../shared/core/failure.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../dtos/change_password_request_dto.dart';
import '../dtos/login_request_dto.dart';
import '../dtos/register_request_dto.dart';
import '../dtos/verify_otp_request_dto.dart';
import '../models/auth_tokens_model.dart';

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
    required String username,
    required String password,
  }) async {
    try {
      final dto = LoginRequestDto(
        username: username,
        password: password,
      );
      
      final resultModel = await remoteDataSource.login(dto);
      
      // Save tokens locally
      await localDataSource.saveTokens(
        AuthTokensModel(
          accessToken: resultModel.tokens.accessToken,
          refreshToken: resultModel.tokens.refreshToken,
        ),
      );
      
      // Convert model to entity
      return Right(resultModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? mobile,
  }) async {
    try {
      final dto = RegisterRequestDto(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        mobile: mobile,
      );
      
      final message = await remoteDataSource.register(dto);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final dto = VerifyOtpRequestDto(email: email, otp: otp);
      
      final resultModel = await remoteDataSource.verifyOtp(dto);
      
      // Save tokens locally
      await localDataSource.saveTokens(
        AuthTokensModel(
          accessToken: resultModel.tokens.accessToken,
          refreshToken: resultModel.tokens.refreshToken,
        ),
      );
      
      // Convert model to entity
      return Right(resultModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp(String email) async {
    try {
      final message = await remoteDataSource.resendOtp(email);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> signInWithGoogle() async {
    try {
      final resultModel = await remoteDataSource.signInWithGoogle();
      
      // Save tokens locally
      await localDataSource.saveTokens(
        AuthTokensModel(
          accessToken: resultModel.tokens.accessToken,
          refreshToken: resultModel.tokens.refreshToken,
        ),
      );
      
      // Convert model to entity
      return Right(resultModel.toEntity());
    } on ServerException catch (e) {
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
  Future<Either<Failure, String>> verifyPasswordResetOtp({
    required String resetToken,
    required String otp,
  }) async {
    try {
      final message = await remoteDataSource.verifyPasswordResetOtp(
        resetToken: resetToken,
        otp: otp,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final message = await remoteDataSource.resetPassword(
        resetToken: resetToken,
        password: newPassword,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final dto = ChangePasswordRequestDto(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      final message = await remoteDataSource.changePassword(dto);
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
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final hasSession = await localDataSource.hasValidSession();
      return Right(hasSession);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to check auth status'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to logout'));
    }
  }
}
