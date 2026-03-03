import 'package:dartz/dartz.dart';
import '../../../../shared/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Map<String, dynamic>>> getUserProfile();
  Future<Either<Failure, Map<String, dynamic>>> updateProfile({
    String? name,
    String? phoneNumber,
    String? bio,
    String? photoUrl,
    String? currency,
    String? displayName,
  });
  Future<Either<Failure, String>> uploadProfilePhoto(String filePath);
  Future<Either<Failure, void>> deleteAccount();
}
