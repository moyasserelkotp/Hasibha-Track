/// Events for password management
abstract class PasswordEvent {
  const PasswordEvent();
}

/// Request password reset email
class ResetPasswordEmailRequested extends PasswordEvent {
  final String email;

  const ResetPasswordEmailRequested(this.email);
}

/// Reset password with code and new password
class ResetPasswordRequested extends PasswordEvent {
  final String email;
  final String code;
  final String newPassword;

  const ResetPasswordRequested({
    required this.email,
    required this.code,
    required this.newPassword,
  });
}
