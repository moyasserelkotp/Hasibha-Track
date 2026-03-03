import 'package:dartz/dartz.dart';
import '../../../../shared/errors/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../dtos/user_profile_dto.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserProfile() async {
    try {
      final dto = await remoteDataSource.getUserProfile();
      return Right(dto.toJson());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateProfile({
    String? name,
    String? phoneNumber,
    String? bio,
    String? photoUrl,
    String? currency,
    String? displayName,
  }) async {
    try {
      final updateDto = UpdateProfileDto(
        displayName: displayName ?? name,
        profilePhoto: photoUrl,
        currency: currency,
      );
      
      final dto = await remoteDataSource.updateProfile(updateDto);
      return Right(dto.toJson());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(String filePath) async {
    try {
      final photoUrl = await remoteDataSource.uploadProfilePhoto(filePath);
      return Right(photoUrl);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
