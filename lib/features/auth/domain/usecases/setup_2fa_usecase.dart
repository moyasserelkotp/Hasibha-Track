import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/two_factor_setup_response.dart';
import '../repositories/auth_repository.dart';

/// Use case for initiating 2FA setup
class Setup2FAUseCase {
  final AuthRepository repository;

  Setup2FAUseCase({required this.repository});

  Future<Either<Failure, TwoFactorSetupResponse>> call() async {
    return await repository.setup2fa();
  }
}
