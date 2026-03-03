import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

class SendSmsUseCase {
  final AuthRepository repository;

  SendSmsUseCase(this.repository);

  Future<Either<Failure, bool>> call(String phone) {
    return repository.sendSmsCode(phone);
  }
}
