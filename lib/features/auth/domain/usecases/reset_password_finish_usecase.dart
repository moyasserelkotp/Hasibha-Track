import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for completing password reset
class ResetPasswordFinishUseCase {
  final AuthRepository repository;

  ResetPasswordFinishUseCase({required this.repository});

  Future<Either<Failure, String>> call({
    required String resetToken,
    required String newPassword,
  }) async {
    return await repository.resetPassword(
      resetToken: resetToken,
      newPassword: newPassword,
    );
  }
}
