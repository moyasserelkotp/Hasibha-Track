/// OTP verification request DTO
/// Used to verify OTP code
class VerifyOtpRequestDto {
  final String email;
  final String otp;

  const VerifyOtpRequestDto({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
