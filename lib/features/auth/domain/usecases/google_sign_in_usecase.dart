import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

/// Use case for Google Sign-In
class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase({required this.repository});

  Future<Either<Failure, AuthResult>> call(String idToken) async {
    return await repository.signInWithGoogle(idToken);
  }
}
