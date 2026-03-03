import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

class VerifySmsUseCase {
  final AuthRepository repository;

  VerifySmsUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String phone,
    required String code,
  }) {
    return repository.verifySmsCode(phone: phone, code: code);
  }
}
