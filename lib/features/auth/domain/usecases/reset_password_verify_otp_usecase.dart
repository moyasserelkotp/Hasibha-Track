import 'package:dartz/dartz.dart';
import '../../../../shared/core/failure.dart';
import '../repositories/auth_repository.dart';

/// Use case for verifying OTP during password reset
class ResetPasswordVerifyOtpUseCase {
  final AuthRepository repository;

  ResetPasswordVerifyOtpUseCase({required this.repository});

  Future<Either<Failure, String>> call({
    required String resetToken,
    required String otp,
  }) async {
    return await repository.verifyPasswordResetOtp(
      resetToken: resetToken,
      otp: otp,
    );
  }
}
