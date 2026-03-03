import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for verifying and enabling 2FA
class Verify2FAUseCase {
  final AuthRepository repository;

  Verify2FAUseCase({required this.repository});

  Future<Either<Failure, List<String>>> call(String token) async {
    return await repository.verify2fa(token);
  }
}
