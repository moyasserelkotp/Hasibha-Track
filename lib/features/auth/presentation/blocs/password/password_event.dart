/// Events for password management
abstract class PasswordEvent {
  const PasswordEvent();
}

/// Request password reset email
class ResetPasswordEmailRequested extends PasswordEvent {
  final String email;

  const ResetPasswordEmailRequested(this.email);
}

/// Verify OTP for password reset
class ResetPasswordOtpRequested extends PasswordEvent {
  final String resetToken;
  final String otp;

  const ResetPasswordOtpRequested({
    required this.resetToken,
    required this.otp,
  });
}

/// Complete password reset
class ResetPasswordFinishRequested extends PasswordEvent {
  final String resetToken;
  final String newPassword;

  const ResetPasswordFinishRequested({
    required this.resetToken,
    required this.newPassword,
  });
}

/// Change password for authenticated user
class ChangePasswordRequested extends PasswordEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });
}
