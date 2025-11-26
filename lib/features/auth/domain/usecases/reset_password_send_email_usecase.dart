import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for sending password reset email
class ResetPasswordSendEmailUseCase {
  final AuthRepository repository;

  ResetPasswordSendEmailUseCase({required this.repository});

  Future<Either<Failure, String>> call(String email) async {
    return await repository.sendPasswordResetEmail(email);
  }
}
