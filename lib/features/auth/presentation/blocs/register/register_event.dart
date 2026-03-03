/// Events for registration functionality
abstract class RegisterEvent {
  const RegisterEvent();
}

/// Register new user
class RegisterRequested extends RegisterEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phone;
  final String? phoneVerificationToken;

  const RegisterRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phone,
    this.phoneVerificationToken,
  });
}
