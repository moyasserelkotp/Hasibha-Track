import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for resending OTP
class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase({required this.repository});

  Future<Either<Failure, String>> call(String email) async {
    return await repository.resendOtp(email);
  }
}
