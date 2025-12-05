/// Registration request DTO (Data Transfer Object)
/// Used to send registration data to the API
class RegisterRequestDto {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phone;
  final String? phoneVerificationToken;

  const RegisterRequestDto({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phone,
    this.phoneVerificationToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      if (phone != null) 'phone': phone,
      if (phoneVerificationToken != null) 'phoneVerificationToken': phoneVerificationToken,
    };
  }
}
