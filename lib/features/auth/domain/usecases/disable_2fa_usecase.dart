import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for disabling 2FA
class Disable2FAUseCase {
  final AuthRepository repository;

  Disable2FAUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    String? token,
    required String password,
  }) async {
    return await repository.disable2fa(
      token: token,
      password: password,
    );
  }
}
