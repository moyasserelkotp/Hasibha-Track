class VerifyOtpLocal {
  final String email;
  final String otp;

  VerifyOtpLocal({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
