import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../entities/two_factor_status.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting 2FA status
class Get2FAStatusUseCase {
  final AuthRepository repository;

  Get2FAStatusUseCase({required this.repository});

  Future<Either<Failure, TwoFactorStatus>> call() async {
    return await repository.get2faStatus();
  }
}
