/// Registration request DTO (Data Transfer Object)
/// Used to send registration data to the API
class RegisterRequestDto {
  final String username;
  final String email;
  final String password;
  final String fullName;
  final String? mobile;

  const RegisterRequestDto({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    this.mobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'full_name': fullName,
      if (mobile != null) 'mobile': mobile,
    };
  }
}
