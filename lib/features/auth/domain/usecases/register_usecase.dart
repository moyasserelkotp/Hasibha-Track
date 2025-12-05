import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, AuthResult>> call({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) async {
    // Validate passwords match
    if (password != confirmPassword) {
      return Left(ValidationFailure(
        message: 'Passwords do not match',
        fieldErrors: const {'confirmPassword': 'Passwords do not match'},
      ));
    }
    
    return await repository.register(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phone: phone,
    );
  }
}
