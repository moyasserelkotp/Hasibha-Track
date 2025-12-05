import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for completing password reset with code
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase({required this.repository});

  Future<Either<Failure, String>> call({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    return await repository.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }
}
