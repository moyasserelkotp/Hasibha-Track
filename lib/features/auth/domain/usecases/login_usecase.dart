import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
/// Supports login with email, phone, or identifier
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  /// Login with email
  Future<Either<Failure, AuthResult>> callWithEmail({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }

  /// Login with phone
  Future<Either<Failure, AuthResult>> callWithPhone({
    required String phone,
    required String password,
  }) async {
    return await repository.login(
      phone: phone,
      password: password,
    );
  }

  /// Login with identifier (email or phone)
  Future<Either<Failure, AuthResult>> call({
    required String identifier,
    required String password,
  }) async {
    return await repository.login(
      identifier: identifier,
      password: password,
    );
  }
}
