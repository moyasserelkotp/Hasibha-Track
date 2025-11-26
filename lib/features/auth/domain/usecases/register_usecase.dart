import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, String>> call({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? mobile,
  }) async {
    return await repository.register(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
      mobile: mobile,
    );
  }
}
