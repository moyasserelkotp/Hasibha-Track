import 'package:dartz/dartz.dart';
import '../../../../shared/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    String? name,
    String? phoneNumber,
    String? bio,
    String? photoUrl,
    String? currency,
    String? displayName,
  }) {
    return repository.updateProfile(
      name: name,
      phoneNumber: phoneNumber,
      bio: bio,
      photoUrl: photoUrl,
      currency: currency,
      displayName: displayName,
    );
  }
}
