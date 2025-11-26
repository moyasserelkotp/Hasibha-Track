/// Events for registration functionality
abstract class RegisterEvent {
  const RegisterEvent();
}

/// Register new user
class RegisterRequested extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final String fullName;
  final String? mobile;

  const RegisterRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    this.mobile,
  });
}

/// Verify OTP after registration
class OtpVerificationRequested extends RegisterEvent {
  final String email;
  final String otp;

  const OtpVerificationRequested({
    required this.email,
    required this.otp,
  });
}

/// Resend OTP
class OtpResendRequested extends RegisterEvent {
  final String email;

  const OtpResendRequested(this.email);
}
